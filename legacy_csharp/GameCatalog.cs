using Godot;
using System.Collections.Generic;

public static class GameCatalog
{
    public const string DefaultHeroId = "forest_ranger";

    public static Dictionary<string, HeroDefinition> CreateHeroDefinitions()
    {
        var heroes = new Dictionary<string, HeroDefinition>();

        heroes["forest_ranger"] = new HeroDefinition
        {
            Id = "forest_ranger",
            DisplayName = "Forest Ranger",
            Description = "Mobile ranged hero focused on arrows, marks and fast repositioning.",
            Stats = new ActorStats
            {
                MaxHealth = 170.0f,
                MoveSpeed = 235.0f,
                AttackDamage = 16.0f,
                AttackRange = 150.0f,
                AttackCooldown = 0.75f,
                GoldReward = 35,
                ExperienceReward = 30
            },
            Abilities = new Godot.Collections.Array<AbilityDefinition>
            {
                Ability("piercing_arrow", "Piercing Arrow", "Shoots through enemies toward the cursor.", AbilityTargeting.Direction, 4.0f, 300.0f, 24.0f, 32.0f),
                Ability("mark_prey", "Mark Prey", "Marks a target for focused burst damage.", AbilityTargeting.SingleTarget, 7.0f, 240.0f, 50.0f, 44.0f),
                Ability("nature_dash", "Nature Dash", "Short dash toward the cursor.", AbilityTargeting.Point, 5.0f, 160.0f, 0.0f, 0.0f),
                Ability("hail_of_arrows", "Hail of Arrows", "Rapid arrows on a selected enemy area.", AbilityTargeting.Area, 10.0f, 260.0f, 80.0f, 70.0f)
            }
        };

        heroes["bard_frog"] = new HeroDefinition
        {
            Id = "bard_frog",
            DisplayName = "Bard Frog",
            Description = "Support hero with healing, ritual zones and disruptive control.",
            Stats = new ActorStats
            {
                MaxHealth = 195.0f,
                MoveSpeed = 215.0f,
                AttackDamage = 12.0f,
                AttackRange = 110.0f,
                AttackCooldown = 0.95f,
                GoldReward = 35,
                ExperienceReward = 30
            },
            Abilities = new Godot.Collections.Array<AbilityDefinition>
            {
                Ability("healing_melody", "Healing Melody", "Heals nearby allies.", AbilityTargeting.Self, 8.0f, 0.0f, 85.0f, 35.0f),
                Ability("swamp_ritual", "Swamp Ritual", "Creates a temporary area that weakens enemies.", AbilityTargeting.Area, 11.0f, 220.0f, 95.0f, 28.0f),
                Ability("frog_jump", "Frog Jump", "Jumps to a point and damages nearby enemies.", AbilityTargeting.Point, 6.0f, 180.0f, 70.0f, 36.0f),
                Ability("sticky_tongue", "Sticky Tongue", "Pull-themed single target strike.", AbilityTargeting.SingleTarget, 7.0f, 210.0f, 42.0f, 38.0f)
            }
        };

        heroes["axe_barbarian"] = new HeroDefinition
        {
            Id = "axe_barbarian",
            DisplayName = "Axe Barbarian",
            Description = "Durable melee hero who wins by staying in the center of combat.",
            Stats = new ActorStats
            {
                MaxHealth = 275.0f,
                MoveSpeed = 205.0f,
                AttackDamage = 24.0f,
                AttackRange = 48.0f,
                AttackCooldown = 0.9f,
                GoldReward = 40,
                ExperienceReward = 35
            },
            Abilities = new Godot.Collections.Array<AbilityDefinition>
            {
                Ability("whirlwind", "Whirlwind", "Damages enemies around the hero.", AbilityTargeting.Self, 6.0f, 0.0f, 78.0f, 34.0f),
                Ability("blood_rage", "Blood Rage", "Self sustain burst based on dealt damage fantasy.", AbilityTargeting.Self, 9.0f, 0.0f, 0.0f, 38.0f),
                Ability("battle_cry", "Battle Cry", "Protects nearby allies.", AbilityTargeting.Self, 10.0f, 0.0f, 90.0f, 24.0f),
                Ability("berserkers_call", "Berserker's Call", "Forces nearby enemies to focus the hero.", AbilityTargeting.Self, 12.0f, 0.0f, 105.0f, 26.0f)
            }
        };

        heroes["sorcerer"] = new HeroDefinition
        {
            Id = "sorcerer",
            DisplayName = "Sorcerer",
            Description = "Fragile caster with strong area damage and control spheres.",
            Stats = new ActorStats
            {
                MaxHealth = 145.0f,
                MoveSpeed = 220.0f,
                AttackDamage = 18.0f,
                AttackRange = 170.0f,
                AttackCooldown = 1.05f,
                GoldReward = 35,
                ExperienceReward = 32
            },
            Abilities = new Godot.Collections.Array<AbilityDefinition>
            {
                Ability("fire_sphere", "Fire Sphere", "Meteor-like damage in target area.", AbilityTargeting.Area, 8.0f, 270.0f, 86.0f, 58.0f),
                Ability("ice_sphere", "Ice Sphere", "Freezes enemies in front of the hero.", AbilityTargeting.Direction, 9.0f, 220.0f, 60.0f, 24.0f),
                Ability("water_sphere", "Water Sphere", "Self heal.", AbilityTargeting.Self, 10.0f, 0.0f, 0.0f, 45.0f),
                Ability("void_sphere", "Void Sphere", "Pulls enemies into the center of a target area.", AbilityTargeting.Area, 13.0f, 260.0f, 100.0f, 36.0f)
            }
        };

        heroes["ancient_druid"] = new HeroDefinition
        {
            Id = "ancient_druid",
            DisplayName = "Ancient Druid",
            Description = "Summoner-controller inspired by wolves, thorns, treants and snakes.",
            Stats = new ActorStats
            {
                MaxHealth = 200.0f,
                MoveSpeed = 210.0f,
                AttackDamage = 15.0f,
                AttackRange = 135.0f,
                AttackCooldown = 0.9f,
                GoldReward = 35,
                ExperienceReward = 32
            },
            Abilities = new Godot.Collections.Array<AbilityDefinition>
            {
                Ability("alpha_wolf", "Alpha Wolf", "Summon placeholder strike near the hero.", AbilityTargeting.Self, 11.0f, 0.0f, 85.0f, 30.0f),
                Ability("thorns", "Thorns", "Periodic damage fantasy in a target area.", AbilityTargeting.Area, 8.0f, 230.0f, 88.0f, 32.0f),
                Ability("summon_treant", "Summon Treant", "Treant lane summon placeholder.", AbilityTargeting.Point, 13.0f, 220.0f, 70.0f, 40.0f),
                Ability("snake_charmer", "Snake Charmer", "Snake-themed chase strike on one target.", AbilityTargeting.SingleTarget, 9.0f, 240.0f, 48.0f, 42.0f)
            }
        };

        return heroes;
    }

    public static Dictionary<string, UnitDefinition> CreateUnitDefinitions()
    {
        return new Dictionary<string, UnitDefinition>
        {
            ["line_melee"] = new UnitDefinition
            {
                Id = "line_melee",
                DisplayName = "Line Swordsman",
                IsLaneUnit = true,
                Stats = new ActorStats
                {
                    MaxHealth = 90.0f,
                    MoveSpeed = 85.0f,
                    AttackDamage = 10.0f,
                    AttackRange = 34.0f,
                    AttackCooldown = 1.15f,
                    GoldReward = 8,
                    ExperienceReward = 6
                },
                Cost = 25,
                UpgradeCost = 60
            },
            ["line_mage"] = new UnitDefinition
            {
                Id = "line_mage",
                DisplayName = "Line Adept",
                IsLaneUnit = true,
                Stats = new ActorStats
                {
                    MaxHealth = 62.0f,
                    MoveSpeed = 78.0f,
                    AttackDamage = 14.0f,
                    AttackRange = 135.0f,
                    AttackCooldown = 1.35f,
                    GoldReward = 10,
                    ExperienceReward = 7
                },
                Cost = 40,
                UpgradeCost = 85
            },
            ["line_siege"] = new UnitDefinition
            {
                Id = "line_siege",
                DisplayName = "Catapult",
                IsLaneUnit = true,
                IsSiegeUnit = true,
                Stats = new ActorStats
                {
                    MaxHealth = 180.0f,
                    MoveSpeed = 45.0f,
                    AttackDamage = 38.0f,
                    AttackRange = 210.0f,
                    AttackCooldown = 2.25f,
                    GoldReward = 22,
                    ExperienceReward = 16
                },
                Cost = 90,
                UpgradeCost = 140
            },
            ["neutral_bruiser"] = Neutral("neutral_bruiser", "Forest Bruiser", 130.0f, 12.0f, 36.0f, 12, 10),
            ["neutral_spitter"] = Neutral("neutral_spitter", "Forest Spitter", 80.0f, 11.0f, 125.0f, 13, 11),
            ["neutral_thrower"] = Neutral("neutral_thrower", "Cone Thrower", 72.0f, 13.0f, 145.0f, 15, 12),
            ["neutral_claw"] = Neutral("neutral_claw", "Claw Beast", 155.0f, 18.0f, 42.0f, 18, 14)
        };
    }

    public static ActorStats CreateEnemyHeroStats()
    {
        return new ActorStats
        {
            MaxHealth = 230.0f,
            MoveSpeed = 180.0f,
            AttackDamage = 18.0f,
            AttackRange = 85.0f,
            AttackCooldown = 1.0f,
            GoldReward = 65,
            ExperienceReward = 55
        };
    }

    private static AbilityDefinition Ability(string id, string displayName, string description, AbilityTargeting targeting, float cooldown, float range, float radius, float power)
    {
        return new AbilityDefinition
        {
            Id = id,
            DisplayName = displayName,
            Description = description,
            Targeting = targeting,
            Cooldown = cooldown,
            Range = range,
            Radius = radius,
            Power = power
        };
    }

    private static UnitDefinition Neutral(string id, string displayName, float health, float damage, float range, int gold, int experience)
    {
        return new UnitDefinition
        {
            Id = id,
            DisplayName = displayName,
            IsLaneUnit = false,
            Stats = new ActorStats
            {
                MaxHealth = health,
                MoveSpeed = 70.0f,
                AttackDamage = damage,
                AttackRange = range,
                AttackCooldown = 1.2f,
                GoldReward = gold,
                ExperienceReward = experience
            }
        };
    }
}
