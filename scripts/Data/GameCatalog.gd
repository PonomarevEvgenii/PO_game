class_name GameCatalog
extends RefCounted

const TEAM_NEUTRAL := "neutral"
const TEAM_PLAYER := "player"
const TEAM_ENEMY := "enemy"

const LANE_TOP := "top"
const LANE_MIDDLE := "middle"
const LANE_BOTTOM := "bottom"

const DEFAULT_HERO_ID := "forest_ranger"
const LANE_UNIT_MOVE_SPEED := 85.0


static func stats(max_health: float, move_speed: float, attack_damage: float, attack_range: float, attack_cooldown: float, gold_reward: int = 0, experience_reward: int = 0, health_regen: float = 0.0) -> Dictionary:
	return {
		"max_health": max_health,
		"move_speed": move_speed,
		"attack_damage": attack_damage,
		"attack_range": attack_range,
		"attack_cooldown": attack_cooldown,
		"health_regen": health_regen,
		"gold_reward": gold_reward,
		"experience_reward": experience_reward,
	}


static func ability(id: String, display_name: String, description: String, targeting: String, cooldown: float, cast_range: float, radius: float, power: float, level_values: Dictionary = {}) -> Dictionary:
	return {
		"id": id,
		"display_name": display_name,
		"description": description,
		"targeting": targeting,
		"cooldown": cooldown,
		"range": cast_range,
		"radius": radius,
		"power": power,
		"level_values": level_values,
	}


static func create_hero_definitions() -> Dictionary:
	return {
		"forest_ranger": {
			"id": "forest_ranger",
			"display_name": "Forest Ranger",
			"description": "Mobile ranged hero focused on arrows, marks and fast repositioning.",
			"stats": stats(170.0, 235.0, 16.0, 150.0, 0.75, 35, 30, 1.2),
			"abilities": [
				ability("piercing_arrow", "Piercing Arrow", "Shoots through enemies toward the cursor.", "direction", 4.0, 300.0, 24.0, 32.0, {
					"power": [32.0, 44.0, 56.0, 68.0],
					"cooldown": [4.0, 3.6, 3.2, 2.8],
					"range": [300.0, 330.0, 360.0, 390.0],
					"radius": [24.0, 27.0, 30.0, 33.0],
				}),
				ability("mark_prey", "Mark Prey", "Marks a target for focused burst damage.", "single_target", 7.0, 240.0, 50.0, 44.0, {
					"power": [44.0, 58.0, 72.0, 86.0],
					"cooldown": [7.0, 6.3, 5.6, 5.0],
					"range": [240.0, 260.0, 280.0, 300.0],
					"duration": [5.0, 5.5, 6.0, 6.5],
					"vulnerability": [1.45, 1.55, 1.65, 1.75],
				}),
				ability("nature_dash", "Nature Dash", "Briefly accelerates the hero.", "self", 5.0, 0.0, 0.0, 0.0, {
					"cooldown": [5.0, 4.4, 3.8, 3.2],
					"duration": [2.4, 2.8, 3.2, 3.6],
					"speed_multiplier": [1.85, 2.0, 2.15, 2.3],
				}),
				ability("hail_of_arrows", "Hail of Arrows", "Rapid arrows on a selected enemy area.", "area", 10.0, 260.0, 80.0, 70.0, {
					"power": [70.0, 92.0, 114.0, 136.0],
					"cooldown": [10.0, 9.0, 8.0, 7.0],
					"range": [260.0, 280.0, 300.0, 320.0],
					"radius": [80.0, 90.0, 100.0, 110.0],
				}),
			],
		},
		"bard_frog": {
			"id": "bard_frog",
			"display_name": "Bard Frog",
			"description": "Support hero with healing, ritual zones and disruptive control.",
			"stats": stats(195.0, 215.0, 12.0, 110.0, 0.95, 35, 30, 1.6),
			"abilities": [
				ability("healing_melody", "Healing Melody", "Heals nearby allies.", "self", 8.0, 0.0, 85.0, 35.0, {
					"power": [35.0, 48.0, 61.0, 74.0],
					"cooldown": [8.0, 7.2, 6.4, 5.6],
					"radius": [85.0, 95.0, 105.0, 115.0],
				}),
				ability("swamp_ritual", "Swamp Ritual", "Creates a temporary area that weakens enemies.", "area", 11.0, 220.0, 95.0, 28.0, {
					"power": [28.0, 38.0, 48.0, 58.0],
					"cooldown": [11.0, 10.0, 9.0, 8.0],
					"radius": [95.0, 108.0, 121.0, 134.0],
					"duration": [4.0, 4.5, 5.0, 5.5],
					"slow_multiplier": [0.62, 0.56, 0.50, 0.44],
					"vulnerability": [1.18, 1.24, 1.30, 1.36],
					"damage_reduction": [0.86, 0.80, 0.74, 0.68],
				}),
				ability("frog_jump", "Frog Jump", "Jumps to a point and damages nearby enemies.", "point", 6.0, 180.0, 70.0, 36.0, {
					"power": [36.0, 50.0, 64.0, 78.0],
					"cooldown": [6.0, 5.4, 4.8, 4.2],
					"range": [180.0, 205.0, 230.0, 255.0],
					"radius": [70.0, 80.0, 90.0, 100.0],
				}),
				ability("sticky_tongue", "Sticky Tongue", "Pull-themed single target strike.", "single_target", 7.0, 210.0, 42.0, 38.0, {
					"power": [38.0, 52.0, 66.0, 80.0],
					"cooldown": [7.0, 6.2, 5.4, 4.6],
					"range": [210.0, 235.0, 260.0, 285.0],
					"pull_distance": [95.0, 115.0, 135.0, 155.0],
					"duration": [2.0, 2.4, 2.8, 3.2],
					"slow_multiplier": [0.55, 0.50, 0.45, 0.40],
				}),
			],
		},
		"axe_barbarian": {
			"id": "axe_barbarian",
			"display_name": "Axe Barbarian",
			"description": "Durable melee hero who wins by staying in the center of combat.",
			"stats": stats(275.0, 205.0, 24.0, 48.0, 0.9, 40, 35, 2.1),
			"abilities": [
				ability("whirlwind", "Whirlwind", "Damages enemies around the hero.", "self", 6.0, 0.0, 78.0, 34.0, {
					"power": [34.0, 49.0, 64.0, 79.0],
					"cooldown": [6.0, 5.4, 4.8, 4.2],
					"radius": [78.0, 88.0, 98.0, 108.0],
				}),
				ability("blood_rage", "Blood Rage", "Self sustain burst.", "self", 9.0, 0.0, 0.0, 38.0, {
					"power": [38.0, 52.0, 66.0, 80.0],
					"cooldown": [9.0, 8.0, 7.0, 6.0],
					"duration": [4.0, 4.8, 5.6, 6.4],
					"speed_multiplier": [1.45, 1.58, 1.71, 1.84],
					"damage_multiplier": [1.35, 1.50, 1.65, 1.80],
				}),
				ability("battle_cry", "Battle Cry", "Protects nearby allies.", "self", 10.0, 0.0, 90.0, 0.0, {
					"cooldown": [10.0, 9.0, 8.0, 7.0],
					"radius": [90.0, 105.0, 120.0, 135.0],
					"duration": [5.0, 5.8, 6.6, 7.4],
					"damage_reduction": [0.62, 0.56, 0.50, 0.44],
				}),
				ability("berserkers_call", "Berserker's Call", "Forces nearby enemies to focus the hero.", "self", 12.0, 0.0, 105.0, 26.0, {
					"power": [26.0, 38.0, 50.0, 62.0],
					"cooldown": [12.0, 11.0, 10.0, 9.0],
					"radius": [105.0, 120.0, 135.0, 150.0],
					"taunt_duration": [3.5, 4.1, 4.7, 5.3],
				}),
			],
		},
		"sorcerer": {
			"id": "sorcerer",
			"display_name": "Sorcerer",
			"description": "Fragile caster with strong area damage and control spheres.",
			"stats": stats(145.0, 220.0, 18.0, 170.0, 1.05, 35, 32, 0.9),
			"abilities": [
				ability("fire_sphere", "Fire Sphere", "Meteor-like damage in target area.", "area", 8.0, 270.0, 86.0, 58.0, {
					"power": [58.0, 78.0, 98.0, 118.0],
					"cooldown": [8.0, 7.2, 6.4, 5.6],
					"range": [270.0, 295.0, 320.0, 345.0],
					"radius": [86.0, 99.0, 112.0, 125.0],
				}),
				ability("ice_sphere", "Ice Sphere", "Freezes enemies in front of the hero.", "direction", 9.0, 220.0, 60.0, 24.0, {
					"power": [24.0, 34.0, 44.0, 54.0],
					"cooldown": [9.0, 8.1, 7.2, 6.3],
					"range": [220.0, 245.0, 270.0, 295.0],
					"radius": [60.0, 70.0, 80.0, 90.0],
					"freeze_duration": [1.8, 2.2, 2.6, 3.0],
				}),
				ability("water_sphere", "Water Sphere", "Self heal.", "self", 10.0, 0.0, 0.0, 45.0, {
					"power": [45.0, 62.0, 79.0, 96.0],
					"cooldown": [10.0, 9.0, 8.0, 7.0],
				}),
				ability("void_sphere", "Void Sphere", "Pulls enemies into target area.", "area", 13.0, 260.0, 100.0, 36.0, {
					"power": [36.0, 50.0, 64.0, 78.0],
					"cooldown": [13.0, 12.0, 11.0, 10.0],
					"range": [260.0, 285.0, 310.0, 335.0],
					"radius": [100.0, 115.0, 130.0, 145.0],
					"pull_distance": [120.0, 145.0, 170.0, 195.0],
					"duration": [2.5, 3.0, 3.5, 4.0],
					"slow_multiplier": [0.35, 0.30, 0.25, 0.20],
				}),
			],
		},
		"ancient_druid": {
			"id": "ancient_druid",
			"display_name": "Ancient Druid",
			"description": "Summoner-controller inspired by wolves, thorns, treants and snakes.",
			"stats": stats(200.0, 210.0, 15.0, 135.0, 0.9, 35, 32, 1.5),
			"abilities": [
				ability("alpha_wolf", "Alpha Wolf", "Summons a wolf that attacks nearby enemies.", "self", 11.0, 0.0, 85.0, 30.0, {
					"power": [30.0, 42.0, 54.0, 66.0],
					"cooldown": [11.0, 10.0, 9.0, 8.0],
					"duration": [22.0, 26.0, 30.0, 34.0],
					"radius": [85.0, 100.0, 115.0, 130.0],
				}),
				ability("thorns", "Thorns", "Damages and slows enemies in a target area.", "area", 8.0, 230.0, 88.0, 32.0, {
					"power": [32.0, 45.0, 58.0, 71.0],
					"cooldown": [8.0, 7.2, 6.4, 5.6],
					"range": [230.0, 255.0, 280.0, 305.0],
					"radius": [88.0, 101.0, 114.0, 127.0],
					"duration": [4.0, 4.6, 5.2, 5.8],
					"slow_multiplier": [0.72, 0.66, 0.60, 0.54],
					"vulnerability": [1.12, 1.18, 1.24, 1.30],
				}),
				ability("summon_treant", "Summon Treant", "Summons a treant that pushes toward the enemy base.", "point", 13.0, 220.0, 70.0, 40.0, {
					"power": [40.0, 56.0, 72.0, 88.0],
					"cooldown": [13.0, 12.0, 11.0, 10.0],
					"range": [220.0, 250.0, 280.0, 310.0],
					"duration": [30.0, 35.0, 40.0, 45.0],
				}),
				ability("snake_charmer", "Snake Charmer", "Snake-themed chase strike on one target.", "single_target", 9.0, 240.0, 48.0, 42.0, {
					"power": [42.0, 57.0, 72.0, 87.0],
					"cooldown": [9.0, 8.1, 7.2, 6.3],
					"range": [240.0, 270.0, 300.0, 330.0],
					"duration": [60.0, 70.0, 80.0, 90.0],
				}),
			],
		},
	}


static func create_unit_definitions() -> Dictionary:
	return {
		"line_melee": {
			"id": "line_melee",
			"display_name": "Line Swordsman",
			"is_lane_unit": true,
			"is_siege_unit": false,
			"cost": 25,
			"upgrade_cost": 60,
			"stats": stats(90.0, LANE_UNIT_MOVE_SPEED, 10.0, 32.0, 1.15, 8, 6),
		},
		"line_mage": {
			"id": "line_mage",
			"display_name": "Line Adept",
			"is_lane_unit": true,
			"is_siege_unit": false,
			"cost": 40,
			"upgrade_cost": 85,
			"stats": stats(62.0, LANE_UNIT_MOVE_SPEED, 14.0, 120.0, 1.35, 10, 7),
		},
		"line_siege": {
			"id": "line_siege",
			"display_name": "Catapult",
			"is_lane_unit": true,
			"is_siege_unit": true,
			"cost": 90,
			"upgrade_cost": 140,
			"stats": stats(180.0, 45.0, 38.0, 190.0, 2.25, 22, 16),
		},
		"neutral_bruiser": neutral("neutral_bruiser", "Forest Bruiser", 130.0, 12.0, 36.0, 12, 10),
		"neutral_spitter": neutral("neutral_spitter", "Forest Spitter", 80.0, 11.0, 125.0, 13, 11),
		"neutral_thrower": neutral("neutral_thrower", "Cone Thrower", 72.0, 13.0, 145.0, 15, 12),
		"neutral_claw": neutral("neutral_claw", "Claw Beast", 155.0, 18.0, 42.0, 18, 14),
	}


static func create_enemy_hero_stats() -> Dictionary:
	return stats(230.0, 180.0, 18.0, 85.0, 1.0, 65, 55)


static func create_tower_stats(tier: int = 1) -> Dictionary:
	var clamped_tier := clampi(tier, 1, 3)
	var health := 520.0 + float(clamped_tier - 1) * 260.0
	var damage := 28.0 + float(clamped_tier - 1) * 18.0
	var attack_range := 155.0 + float(clamped_tier - 1) * 10.0
	var gold := 65 + (clamped_tier - 1) * 35
	var experience := 45 + (clamped_tier - 1) * 25
	return stats(health, 0.0, damage, attack_range, 0.82, gold, experience)


static func neutral(id: String, display_name: String, health: float, damage: float, attack_range: float, gold: int, experience: int) -> Dictionary:
	return {
		"id": id,
		"display_name": display_name,
		"is_lane_unit": false,
		"is_siege_unit": false,
		"cost": 0,
		"upgrade_cost": 0,
		"stats": stats(health, 70.0, damage, attack_range, 1.2, gold, experience),
	}
