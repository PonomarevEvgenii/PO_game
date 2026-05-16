using Godot;

public partial class Actor : CharacterBody2D
{
    [Signal] public delegate void DiedEventHandler(Actor victim, Actor killer);
    [Signal] public delegate void HealthChangedEventHandler(float current, float maximum);

    [Export] public TeamId Team { get; set; } = TeamId.Neutral;
    [Export] public LaneId Lane { get; set; } = LaneId.Middle;
    [Export] public ActorStats Stats { get; set; } = new ActorStats();
    [Export] public float DrawRadius { get; set; } = 12.0f;

    private float _health;
    private float _attackCooldown;

    public float Health => _health;
    public bool IsAlive => _health > 0.0f;

    public override void _Ready()
    {
        Stats ??= new ActorStats();

        if (_health <= 0.0f)
        {
            _health = Stats.MaxHealth;
        }

        RefreshGroups();
        EmitSignal(SignalName.HealthChanged, _health, Stats.MaxHealth);
    }

    public override void _PhysicsProcess(double delta)
    {
        if (_attackCooldown > 0.0f)
        {
            _attackCooldown = Mathf.Max(0.0f, _attackCooldown - (float)delta);
        }
    }

    public virtual void Configure(TeamId team, LaneId lane, ActorStats stats)
    {
        Team = team;
        Lane = lane;
        Stats = stats != null ? stats.CloneStats() : new ActorStats();
        _health = Stats.MaxHealth;
        _attackCooldown = 0.0f;
        RefreshGroups();
        EmitSignal(SignalName.HealthChanged, _health, Stats.MaxHealth);
        QueueRedraw();
    }

    public virtual void TakeDamage(float amount, Actor source)
    {
        if (!IsAlive || amount <= 0.0f)
        {
            return;
        }

        _health = Mathf.Max(0.0f, _health - amount);
        EmitSignal(SignalName.HealthChanged, _health, Stats.MaxHealth);
        QueueRedraw();

        if (_health <= 0.0f)
        {
            Die(source);
        }
    }

    public void Heal(float amount)
    {
        if (!IsAlive || amount <= 0.0f)
        {
            return;
        }

        _health = Mathf.Min(Stats.MaxHealth, _health + amount);
        EmitSignal(SignalName.HealthChanged, _health, Stats.MaxHealth);
        QueueRedraw();
    }

    public bool CanDamage(Actor other)
    {
        if (other == null || other == this || !other.IsAlive || Team == other.Team)
        {
            return false;
        }

        return Team != TeamId.Neutral || other.Team != TeamId.Neutral;
    }

    public bool TryAttack(Actor target)
    {
        if (_attackCooldown > 0.0f || !CanDamage(target))
        {
            return false;
        }

        if (GlobalPosition.DistanceTo(target.GlobalPosition) > Stats.AttackRange)
        {
            return false;
        }

        target.TakeDamage(Stats.AttackDamage, this);
        _attackCooldown = Stats.AttackCooldown;
        return true;
    }

    public Actor FindNearestEnemy(float radius)
    {
        Actor best = null;
        var bestDistanceSquared = radius * radius;

        foreach (var node in GetTree().GetNodesInGroup("combat_actor"))
        {
            if (node is not Actor actor || !CanDamage(actor))
            {
                continue;
            }

            var distanceSquared = GlobalPosition.DistanceSquaredTo(actor.GlobalPosition);
            if (distanceSquared < bestDistanceSquared)
            {
                best = actor;
                bestDistanceSquared = distanceSquared;
            }
        }

        return best;
    }

    public override void _Draw()
    {
        var color = GetTeamColor();
        DrawCircle(Vector2.Zero, DrawRadius, color);
        DrawArc(Vector2.Zero, DrawRadius + 2.0f, 0.0f, Mathf.Tau, 24, Colors.Black, 1.5f);
    }

    protected virtual Color GetTeamColor()
    {
        return Team switch
        {
            TeamId.Player => new Color(0.25f, 0.78f, 0.38f),
            TeamId.Enemy => new Color(0.88f, 0.24f, 0.22f),
            _ => new Color(0.85f, 0.72f, 0.32f)
        };
    }

    private void Die(Actor killer)
    {
        SetPhysicsProcess(false);
        EmitSignal(SignalName.Died, this, killer);
        QueueFree();
    }

    private void RefreshGroups()
    {
        AddToGroup("combat_actor");

        foreach (var group in new[] { "team_neutral", "team_player", "team_enemy" })
        {
            if (IsInGroup(group))
            {
                RemoveFromGroup(group);
            }
        }

        AddToGroup($"team_{Team.ToString().ToLowerInvariant()}");
    }
}
