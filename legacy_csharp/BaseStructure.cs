using Godot;

public partial class BaseStructure : Actor
{
    [Export] public Vector2 Size { get; set; } = new Vector2(78.0f, 92.0f);

    public void ConfigureBase(TeamId team, Vector2 position)
    {
        GlobalPosition = position;
        Configure(team, LaneId.Middle, new ActorStats
        {
            MaxHealth = 1200.0f,
            MoveSpeed = 0.0f,
            AttackDamage = 0.0f,
            AttackRange = 0.0f,
            AttackCooldown = 1.0f,
            GoldReward = 0,
            ExperienceReward = 0
        });
    }

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        Velocity = Vector2.Zero;
    }

    public override void _Draw()
    {
        var rect = new Rect2(-Size / 2.0f, Size);
        DrawRect(rect, GetTeamColor());
        DrawRect(rect, Colors.Black, false, 2.0f);
    }
}
