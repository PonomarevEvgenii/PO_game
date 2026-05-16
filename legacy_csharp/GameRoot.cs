using Godot;

public partial class GameRoot : Node
{
    [Export] public PackedScene MainMenuScene { get; set; }
    [Export] public PackedScene HeroSelectScene { get; set; }
    [Export] public PackedScene GameWorldScene { get; set; }

    private Node _currentScreen;

    public override void _Ready()
    {
        LoadDefaultScenes();
        ShowMainMenu();
    }

    private void LoadDefaultScenes()
    {
        MainMenuScene ??= GD.Load<PackedScene>("res://scenes/Menu/MainMenu.tscn");
        HeroSelectScene ??= GD.Load<PackedScene>("res://scenes/UI/HeroSelect.tscn");
        GameWorldScene ??= GD.Load<PackedScene>("res://scenes/World/GameWorld.tscn");
    }

    private void ShowMainMenu()
    {
        var menu = MainMenuScene.Instantiate<MainMenuController>();
        menu.StartPressed += ShowHeroSelect;
        menu.QuitPressed += QuitGame;
        ReplaceScreen(menu);
    }

    private void ShowHeroSelect()
    {
        var heroSelect = HeroSelectScene.Instantiate<HeroSelectController>();
        heroSelect.HeroChosen += StartGame;
        heroSelect.BackRequested += ShowMainMenu;
        ReplaceScreen(heroSelect);
    }

    private void StartGame(string heroId)
    {
        var world = GameWorldScene.Instantiate<GameWorld>();
        world.SelectedHeroId = heroId;
        world.GameEnded += OnGameEnded;
        ReplaceScreen(world);
    }

    private void OnGameEnded(bool victory)
    {
        GD.Print(victory ? "Victory" : "Defeat");
        ShowMainMenu();
    }

    private void QuitGame()
    {
        GetTree().Quit();
    }

    private void ReplaceScreen(Node nextScreen)
    {
        if (_currentScreen != null)
        {
            RemoveChild(_currentScreen);
            _currentScreen.QueueFree();
        }

        _currentScreen = nextScreen;
        AddChild(_currentScreen);
    }
}
