using Godot;

[GlobalClass]
public partial class ActorStats : Resource
{
    [Export] public float MaxHealth { get; set; } = 100.0f;
    [Export] public float MoveSpeed { get; set; } = 120.0f;
    [Export] public float AttackDamage { get; set; } = 10.0f;
    [Export] public float AttackRange { get; set; } = 42.0f;
    [Export] public float AttackCooldown { get; set; } = 1.0f;
    [Export] public int GoldReward { get; set; } = 5;
    [Export] public int ExperienceReward { get; set; } = 4;

    public ActorStats CloneStats()
    {
        return new ActorStats
        {
            MaxHealth = MaxHealth,
            MoveSpeed = MoveSpeed,
            AttackDamage = AttackDamage,
            AttackRange = AttackRange,
            AttackCooldown = AttackCooldown,
            GoldReward = GoldReward,
            ExperienceReward = ExperienceReward
        };
    }
}
