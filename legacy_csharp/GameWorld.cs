using Godot;
using System.Collections.Generic;

public partial class GameWorld : Node2D
{
    [Signal] public delegate void GameEndedEventHandler(bool victory);

    [Export] public string SelectedHeroId { get; set; } = GameCatalog.DefaultHeroId;
    [Export] public PackedScene PlayerHeroScene { get; set; }
    [Export] public PackedScene EnemyHeroScene { get; set; }
    [Export] public PackedScene LaneUnitScene { get; set; }
    [Export] public PackedScene NeutralUnitScene { get; set; }
    [Export] public PackedScene BaseScene { get; set; }
    [Export] public PackedScene HudScene { get; set; }
    [Export] public PackedScene ShopScene { get; set; }

    private Node2D _actors;
    private Node2D _structures;
    private LaneManager _laneManager;
    private WaveSpawner _waveSpawner;
    private NeutralCampSpawner _neutralSpawner;
    private EconomySystem _economy;
    private ExperienceSystem _experience;
    private ShopSystem _shop;
    private HeroController _playerHero;
    private ShopController _shopPanel;
    private bool _matchEnded;

    public override void _Ready()
    {
        LoadDefaultScenes();

        _actors = GetOrCreateNode2D("Actors");
        _structures = GetOrCreateNode2D("Structures");
        _laneManager = GetOrCreateChild<LaneManager>("LaneManager");
        _waveSpawner = GetOrCreateSystem<WaveSpawner>("WaveSpawner");
        _neutralSpawner = GetOrCreateSystem<NeutralCampSpawner>("NeutralCampSpawner");
        _economy = GetOrCreateSystem<EconomySystem>("EconomySystem");
        _experience = GetOrCreateSystem<ExperienceSystem>("ExperienceSystem");
        _shop = GetOrCreateSystem<ShopSystem>("ShopSystem");

        _economy.ResetEconomy();
        _experience.ResetProgress();
        _shop.Bind(_economy);
        _shop.UnitUpgraded += OnUnitUpgraded;

        _waveSpawner.Configure(_actors, LaneUnitScene, _laneManager);
        _waveSpawner.UnitSpawned += RegisterActor;
        _neutralSpawner.Configure(_actors, NeutralUnitScene);
        _neutralSpawner.UnitSpawned += RegisterActor;

        SpawnBases();
        SpawnPlayerHero();
        SpawnEnemyHero();
        _neutralSpawner.SpawnInitialCamps();
        _waveSpawner.StartSpawning();
        CreateUi();
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (@event is InputEventKey key && key.Pressed && !key.Echo && key.Keycode == Key.B)
        {
            _shopPanel?.Toggle();
        }
    }

    private void LoadDefaultScenes()
    {
        PlayerHeroScene ??= GD.Load<PackedScene>("res://scenes/Characters/Hero.tscn");
        EnemyHeroScene ??= GD.Load<PackedScene>("res://scenes/Characters/EnemyHero.tscn");
        LaneUnitScene ??= GD.Load<PackedScene>("res://scenes/Units/LaneUnit.tscn");
        NeutralUnitScene ??= GD.Load<PackedScene>("res://scenes/Units/NeutralUnit.tscn");
        BaseScene ??= GD.Load<PackedScene>("res://scenes/Structures/BaseStructure.tscn");
        HudScene ??= GD.Load<PackedScene>("res://scenes/UI/InGameHud.tscn");
        ShopScene ??= GD.Load<PackedScene>("res://scenes/UI/ShopPanel.tscn");
    }

    private void SpawnBases()
    {
        SpawnBase(TeamId.Player);
        SpawnBase(TeamId.Enemy);
    }

    private void SpawnBase(TeamId team)
    {
        var baseStructure = BaseScene.Instantiate<BaseStructure>();
        _structures.AddChild(baseStructure);
        baseStructure.ConfigureBase(team, _laneManager.GetBasePosition(team));
        RegisterActor(baseStructure);
    }

    private void SpawnPlayerHero()
    {
        var heroes = GameCatalog.CreateHeroDefinitions();
        if (!heroes.TryGetValue(SelectedHeroId, out var definition))
        {
            definition = heroes[GameCatalog.DefaultHeroId];
        }

        _playerHero = PlayerHeroScene.Instantiate<HeroController>();
        _actors.AddChild(_playerHero);
        _playerHero.ConfigureHero(definition);
        _playerHero.GlobalPosition = _laneManager.GetHeroSpawn(TeamId.Player);
        RegisterActor(_playerHero);
    }

    private void SpawnEnemyHero()
    {
        var enemyHero = EnemyHeroScene.Instantiate<EnemyHeroAi>();
        _actors.AddChild(enemyHero);
        enemyHero.Configure(TeamId.Enemy, LaneId.Middle, GameCatalog.CreateEnemyHeroStats());
        enemyHero.GlobalPosition = _laneManager.GetHeroSpawn(TeamId.Enemy);
        enemyHero.ObjectivePosition = _laneManager.GetBasePosition(TeamId.Player);
        RegisterActor(enemyHero);
    }

    private void CreateUi()
    {
        var uiLayer = GetOrCreateChild<CanvasLayer>("UI");

        var hud = HudScene.Instantiate<InGameHudController>();
        uiLayer.AddChild(hud);
        hud.Bind(_economy, _experience, _playerHero);
        hud.ShopRequested += ToggleShop;

        _shopPanel = ShopScene.Instantiate<ShopController>();
        uiLayer.AddChild(_shopPanel);
        _shopPanel.Bind(_shop, _economy);
        _shopPanel.Visible = false;
    }

    private void RegisterActor(Actor actor)
    {
        if (actor == null)
        {
            return;
        }

        actor.Died += OnActorDied;
    }

    private void OnActorDied(Actor victim, Actor killer)
    {
        if (_matchEnded || victim == null)
        {
            return;
        }

        if (killer != null && killer.Team == TeamId.Player && victim.Team != TeamId.Player)
        {
            _economy.AddGold(victim.Stats.GoldReward);
            _experience.AddExperience(victim.Stats.ExperienceReward);
        }

        if (victim is BaseStructure)
        {
            _matchEnded = true;
            _waveSpawner.StopSpawning();
            EmitSignal(SignalName.GameEnded, victim.Team == TeamId.Enemy);
        }
    }

    private void OnUnitUpgraded(string unitId, int level)
    {
        _waveSpawner.SetUnitUpgradeLevel(unitId, level);
    }

    private void ToggleShop()
    {
        _shopPanel?.Toggle();
    }

    private Node2D GetOrCreateNode2D(string childName)
    {
        var node = GetNodeOrNull<Node2D>(childName);
        if (node != null)
        {
            return node;
        }

        node = new Node2D { Name = childName };
        AddChild(node);
        return node;
    }

    private T GetOrCreateChild<T>(string childName) where T : Node, new()
    {
        var node = GetNodeOrNull<T>(childName);
        if (node != null)
        {
            return node;
        }

        node = new T { Name = childName };
        AddChild(node);
        return node;
    }

    private T GetOrCreateSystem<T>(string childName) where T : Node, new()
    {
        var systems = GetNodeOrNull<Node>("Systems");
        if (systems == null)
        {
            systems = new Node { Name = "Systems" };
            AddChild(systems);
        }

        var node = systems.GetNodeOrNull<T>(childName);
        if (node != null)
        {
            return node;
        }

        node = new T { Name = childName };
        systems.AddChild(node);
        return node;
    }
}
