using Godot;

public partial class NeutralUnit : Actor
{
    [Export] public float LeashRadius { get; set; } = 180.0f;
    [Export] public string UnitId { get; set; } = "neutral_bruiser";

    private Vector2 _homePosition;
    private Actor _aggroTarget;

    public override void _Ready()
    {
        base._Ready();
        _homePosition = GlobalPosition;
    }

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);

        if (!IsAlive)
        {
            Velocity = Vector2.Zero;
            return;
        }

        if (_aggroTarget == null || !_aggroTarget.IsInsideTree() || !_aggroTarget.IsAlive)
        {
            _aggroTarget = FindNearestEnemy(90.0f);
        }

        if (_aggroTarget != null && GlobalPosition.DistanceTo(_homePosition) <= LeashRadius)
        {
            if (!TryAttack(_aggroTarget))
            {
                Velocity = GlobalPosition.DirectionTo(_aggroTarget.GlobalPosition) * Stats.MoveSpeed;
            }
            else
            {
                Velocity = Vector2.Zero;
            }
        }
        else
        {
            ReturnHome();
        }

        MoveAndSlide();
    }

    public override void TakeDamage(float amount, Actor source)
    {
        if (source != null)
        {
            _aggroTarget = source;
        }

        base.TakeDamage(amount, source);
    }

    public void ConfigureNeutral(string unitId, Vector2 position, ActorStats stats)
    {
        UnitId = unitId;
        GlobalPosition = position;
        _homePosition = position;
        Configure(TeamId.Neutral, LaneId.Middle, stats);
    }

    private void ReturnHome()
    {
        if (GlobalPosition.DistanceTo(_homePosition) < 6.0f)
        {
            Velocity = Vector2.Zero;
            _aggroTarget = null;
            return;
        }

        Velocity = GlobalPosition.DirectionTo(_homePosition) * Stats.MoveSpeed;
    }
}
