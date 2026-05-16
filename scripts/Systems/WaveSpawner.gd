class_name WaveSpawner
extends Node

signal wave_started(wave_number: int)
signal unit_spawned(actor: Actor)

@export var spawn_interval := 8.0

var _upgrade_levels := {}
var _actor_parent: Node2D
var _lane_unit_scene: PackedScene
var _lane_manager: LaneManager
var _timer := 0.0
var _wave_number := 0
var _running := false


func _process(delta: float) -> void:
	if not _running or _actor_parent == null or _lane_unit_scene == null or _lane_manager == null:
		return

	_timer -= delta
	if _timer <= 0.0:
		_spawn_wave()
		_timer = spawn_interval


func configure(actor_parent: Node2D, lane_unit_scene: PackedScene, lane_manager: LaneManager) -> void:
	_actor_parent = actor_parent
	_lane_unit_scene = lane_unit_scene
	_lane_manager = lane_manager


func start_spawning() -> void:
	_running = true
	_timer = 1.0


func stop_spawning() -> void:
	_running = false


func set_unit_upgrade_level(unit_id: String, level: int) -> void:
	_upgrade_levels[unit_id] = level


func _spawn_wave() -> void:
	_wave_number += 1
	wave_started.emit(_wave_number)

	for lane in [GameCatalog.LANE_TOP, GameCatalog.LANE_MIDDLE, GameCatalog.LANE_BOTTOM]:
		_spawn_lane_pair("line_melee", lane)
		_spawn_lane_pair("line_mage", lane)

		if _wave_number % 3 == 0:
			_spawn_lane_pair("line_siege", lane)


func _spawn_lane_pair(unit_id: String, lane: String) -> void:
	_spawn_unit(unit_id, GameCatalog.TEAM_PLAYER, lane)
	_spawn_unit(unit_id, GameCatalog.TEAM_ENEMY, lane)


func _spawn_unit(unit_id: String, team: String, lane: String) -> void:
	var definitions := GameCatalog.create_unit_definitions()
	if not definitions.has(unit_id):
		return

	var definition: Dictionary = definitions[unit_id]
	var unit := _lane_unit_scene.instantiate() as LaneUnit
	_actor_parent.add_child(unit)
	var path := _lane_manager.get_lane_path(team, lane)
	if path.size() > 1:
		path[0] = path[0].move_toward(path[1], _lane_manager.spawn_offset_from_base)

	unit.configure_lane_unit(
		unit_id,
		team,
		lane,
		path,
		_create_scaled_stats(definition)
	)
	unit_spawned.emit(unit)


func _create_scaled_stats(definition: Dictionary) -> Dictionary:
	var unit_stats: Dictionary = definition.get("stats", {}).duplicate(true)
	var level := int(_upgrade_levels.get(String(definition.get("id", "")), 0))
	var multiplier := 1.0 + float(level) * 0.15
	unit_stats["max_health"] = float(unit_stats.get("max_health", 1.0)) * multiplier
	unit_stats["attack_damage"] = float(unit_stats.get("attack_damage", 1.0)) * multiplier
	return unit_stats
