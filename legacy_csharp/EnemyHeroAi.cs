using Godot;

public partial class EnemyHeroAi : Actor
{
    [Export] public Vector2 ObjectivePosition { get; set; }
    [Export] public float AggroRange { get; set; } = 260.0f;

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);

        if (!IsAlive)
        {
            Velocity = Vector2.Zero;
            return;
        }

        var target = FindNearestEnemy(AggroRange);
        if (target != null)
        {
            if (!TryAttack(target))
            {
                MoveToward(target.GlobalPosition);
            }
            else
            {
                Velocity = Vector2.Zero;
            }
        }
        else
        {
            MoveToward(ObjectivePosition);
        }

        MoveAndSlide();
    }

    private void MoveToward(Vector2 point)
    {
        if (GlobalPosition.DistanceTo(point) < 8.0f)
        {
            Velocity = Vector2.Zero;
            return;
        }

        Velocity = GlobalPosition.DirectionTo(point) * Stats.MoveSpeed;
    }
}
