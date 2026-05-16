using Godot;
using System;

public partial class AbilityCaster : Node
{
    [Export] public NodePath OwnerActorPath { get; set; } = new NodePath("..");
    [Export] public Godot.Collections.Array<AbilityDefinition> Abilities { get; set; } = new Godot.Collections.Array<AbilityDefinition>();

    private Actor _owner;
    private float[] _cooldowns = Array.Empty<float>();

    public override void _Ready()
    {
        _owner = GetNodeOrNull<Actor>(OwnerActorPath);
        ResetCooldowns();
    }

    public override void _Process(double delta)
    {
        for (var i = 0; i < _cooldowns.Length; i++)
        {
            if (_cooldowns[i] > 0.0f)
            {
                _cooldowns[i] = Mathf.Max(0.0f, _cooldowns[i] - (float)delta);
            }
        }
    }

    public void SetAbilities(Godot.Collections.Array<AbilityDefinition> abilities)
    {
        Abilities = abilities ?? new Godot.Collections.Array<AbilityDefinition>();
        ResetCooldowns();
    }

    public bool Cast(int slot, Vector2 targetPosition)
    {
        if (_owner == null || slot < 0 || slot >= Abilities.Count || slot >= _cooldowns.Length)
        {
            return false;
        }

        var ability = Abilities[slot];
        if (ability == null || _cooldowns[slot] > 0.0f)
        {
            return false;
        }

        ExecuteAbility(ability, targetPosition);
        _cooldowns[slot] = ability.Cooldown;
        return true;
    }

    public float GetCooldown(int slot)
    {
        if (slot < 0 || slot >= _cooldowns.Length)
        {
            return 0.0f;
        }

        return _cooldowns[slot];
    }

    private void ExecuteAbility(AbilityDefinition ability, Vector2 targetPosition)
    {
        switch (ability.Id)
        {
            case "nature_dash":
                DashToward(targetPosition, ability.Range);
                break;
            case "frog_jump":
                DashToward(targetPosition, ability.Range);
                DamageEnemiesInRadius(_owner.GlobalPosition, ability.Radius, ability.Power);
                break;
            case "healing_melody":
            case "water_sphere":
            case "blood_rage":
                HealAlliesInRadius(_owner.GlobalPosition, Mathf.Max(ability.Radius, 20.0f), ability.Power);
                break;
            case "piercing_arrow":
            case "ice_sphere":
                DamageEnemiesAlongLine(_owner.GlobalPosition, targetPosition, ability.Radius, ability.Power);
                break;
            case "mark_prey":
            case "sticky_tongue":
            case "snake_charmer":
                DamageNearestEnemyToPoint(targetPosition, ability.Range, ability.Power);
                break;
            default:
                DamageEnemiesInRadius(targetPosition, Mathf.Max(ability.Radius, 32.0f), ability.Power);
                break;
        }

        GD.Print($"{_owner.Name} cast {ability.DisplayName}");
    }

    private void DashToward(Vector2 targetPosition, float maxDistance)
    {
        var destination = _owner.GlobalPosition.MoveToward(targetPosition, maxDistance);
        _owner.GlobalPosition = destination;
    }

    private void HealAlliesInRadius(Vector2 center, float radius, float amount)
    {
        foreach (var node in GetTree().GetNodesInGroup("combat_actor"))
        {
            if (node is Actor actor && actor.Team == _owner.Team && actor.GlobalPosition.DistanceTo(center) <= radius)
            {
                actor.Heal(amount);
            }
        }
    }

    private void DamageEnemiesInRadius(Vector2 center, float radius, float damage)
    {
        foreach (var node in GetTree().GetNodesInGroup("combat_actor"))
        {
            if (node is Actor actor && _owner.CanDamage(actor) && actor.GlobalPosition.DistanceTo(center) <= radius)
            {
                actor.TakeDamage(damage, _owner);
            }
        }
    }

    private void DamageEnemiesAlongLine(Vector2 origin, Vector2 targetPosition, float width, float damage)
    {
        var end = origin.MoveToward(targetPosition, Mathf.Max(origin.DistanceTo(targetPosition), 1.0f));

        foreach (var node in GetTree().GetNodesInGroup("combat_actor"))
        {
            if (node is not Actor actor || !_owner.CanDamage(actor))
            {
                continue;
            }

            if (DistancePointToSegment(actor.GlobalPosition, origin, end) <= Mathf.Max(width, 18.0f))
            {
                actor.TakeDamage(damage, _owner);
            }
        }
    }

    private void DamageNearestEnemyToPoint(Vector2 point, float searchRadius, float damage)
    {
        Actor best = null;
        var bestDistanceSquared = searchRadius * searchRadius;

        foreach (var node in GetTree().GetNodesInGroup("combat_actor"))
        {
            if (node is not Actor actor || !_owner.CanDamage(actor))
            {
                continue;
            }

            var distanceSquared = point.DistanceSquaredTo(actor.GlobalPosition);
            if (distanceSquared < bestDistanceSquared)
            {
                best = actor;
                bestDistanceSquared = distanceSquared;
            }
        }

        best?.TakeDamage(damage, _owner);
    }

    private void ResetCooldowns()
    {
        _cooldowns = new float[Abilities.Count];
    }

    private static float DistancePointToSegment(Vector2 point, Vector2 start, Vector2 end)
    {
        var segment = end - start;
        var lengthSquared = segment.LengthSquared();

        if (lengthSquared <= 0.001f)
        {
            return point.DistanceTo(start);
        }

        var t = Mathf.Clamp((point - start).Dot(segment) / lengthSquared, 0.0f, 1.0f);
        var projection = start + segment * t;
        return point.DistanceTo(projection);
    }
}
