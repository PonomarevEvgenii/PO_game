using Godot;

public partial class LaneUnit : Actor
{
    [Export] public Vector2 LaneTarget { get; set; }
    [Export] public string UnitId { get; set; } = "line_melee";

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);

        if (!IsAlive)
        {
            Velocity = Vector2.Zero;
            return;
        }

        var enemy = FindNearestEnemy(Stats.AttackRange);
        if (enemy != null)
        {
            Velocity = Vector2.Zero;
            TryAttack(enemy);
        }
        else
        {
            MoveAlongLane();
        }

        MoveAndSlide();
    }

    public void ConfigureLaneUnit(string unitId, TeamId team, LaneId lane, Vector2 spawnPosition, Vector2 targetPosition, ActorStats stats)
    {
        UnitId = unitId;
        GlobalPosition = spawnPosition;
        LaneTarget = targetPosition;
        Configure(team, lane, stats);
    }

    private void MoveAlongLane()
    {
        if (GlobalPosition.DistanceTo(LaneTarget) < 10.0f)
        {
            Velocity = Vector2.Zero;
            return;
        }

        Velocity = GlobalPosition.DirectionTo(LaneTarget) * Stats.MoveSpeed;
    }
}
