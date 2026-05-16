using Godot;

public partial class HeroController : Actor
{
    [Export] public NodePath AbilityCasterPath { get; set; } = new NodePath("AbilityCaster");

    private AbilityCaster _abilityCaster;
    private string _heroId = GameCatalog.DefaultHeroId;

    public string HeroId => _heroId;

    public override void _Ready()
    {
        base._Ready();
        _abilityCaster = GetNodeOrNull<AbilityCaster>(AbilityCasterPath);
    }

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);

        if (!IsAlive)
        {
            Velocity = Vector2.Zero;
            return;
        }

        var input = Vector2.Zero;
        if (Input.IsKeyPressed(Key.W) || Input.IsKeyPressed(Key.Up))
        {
            input.Y -= 1.0f;
        }

        if (Input.IsKeyPressed(Key.S) || Input.IsKeyPressed(Key.Down))
        {
            input.Y += 1.0f;
        }

        if (Input.IsKeyPressed(Key.A) || Input.IsKeyPressed(Key.Left))
        {
            input.X -= 1.0f;
        }

        if (Input.IsKeyPressed(Key.D) || Input.IsKeyPressed(Key.Right))
        {
            input.X += 1.0f;
        }

        Velocity = input.LengthSquared() > 0.0f ? input.Normalized() * Stats.MoveSpeed : Vector2.Zero;

        if (Velocity == Vector2.Zero)
        {
            var nearbyTarget = FindNearestEnemy(Stats.AttackRange);
            TryAttack(nearbyTarget);
        }

        MoveAndSlide();
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (!IsAlive || _abilityCaster == null)
        {
            return;
        }

        if (@event is InputEventKey key && key.Pressed && !key.Echo)
        {
            var mousePosition = GetGlobalMousePosition();

            if (key.Keycode == Key.Key1)
            {
                _abilityCaster.Cast(0, mousePosition);
            }
            else if (key.Keycode == Key.Key2)
            {
                _abilityCaster.Cast(1, mousePosition);
            }
            else if (key.Keycode == Key.Key3)
            {
                _abilityCaster.Cast(2, mousePosition);
            }
            else if (key.Keycode == Key.Key4)
            {
                _abilityCaster.Cast(3, mousePosition);
            }
        }
    }

    public void ConfigureHero(HeroDefinition definition)
    {
        if (definition == null)
        {
            return;
        }

        _heroId = definition.Id;
        Configure(TeamId.Player, LaneId.Middle, definition.Stats);

        _abilityCaster ??= GetNodeOrNull<AbilityCaster>(AbilityCasterPath);
        _abilityCaster?.SetAbilities(definition.Abilities);
    }
}
