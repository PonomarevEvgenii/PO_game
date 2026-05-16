class_name LaneManager
extends Node2D

@export var player_base_position := Vector2(-900.0, 520.0)
@export var enemy_base_position := Vector2(900.0, -520.0)
@export var spawn_offset_from_base := 78.0


func _ready() -> void:
	z_index = -50
	queue_redraw()


func get_base_position(team: String) -> Vector2:
	return player_base_position if team == GameCatalog.TEAM_PLAYER else enemy_base_position


func get_hero_spawn(team: String) -> Vector2:
	var base_position := get_base_position(team)
	return base_position + Vector2(145.0, -95.0) if team == GameCatalog.TEAM_PLAYER else base_position + Vector2(-145.0, 95.0)


func get_spawn_position(team: String, lane: String) -> Vector2:
	var path := get_lane_path(team, lane)
	if path.size() < 2:
		return get_base_position(team)

	return path[0].move_toward(path[1], spawn_offset_from_base)


func get_lane_target(team: String, lane: String) -> Vector2:
	var path := get_lane_path(team, lane)
	return path[path.size() - 1] if path.size() > 0 else get_base_position(GameCatalog.TEAM_ENEMY)


func get_lane_path(team: String, lane: String) -> PackedVector2Array:
	var path := _get_player_lane_path(lane)
	if team == GameCatalog.TEAM_ENEMY:
		var reversed := PackedVector2Array()
		for i in range(path.size() - 1, -1, -1):
			reversed.append(path[i])
		return reversed

	return path


func get_lane_tower_positions(team: String) -> Array[Vector2]:
	if team == GameCatalog.TEAM_PLAYER:
		return [
			Vector2(-970.0, 210.0),
			Vector2(-620.0, -540.0),
			Vector2(-450.0, 260.0),
			Vector2(-30.0, 25.0),
			Vector2(-380.0, 610.0),
			Vector2(560.0, 500.0),
		]

	return [
		Vector2(970.0, -210.0),
		Vector2(620.0, 540.0),
		Vector2(450.0, -260.0),
		Vector2(30.0, -25.0),
		Vector2(380.0, -610.0),
		Vector2(-560.0, -500.0),
	]


func _draw() -> void:
	for lane in [GameCatalog.LANE_TOP, GameCatalog.LANE_MIDDLE, GameCatalog.LANE_BOTTOM]:
		_draw_lane(lane)


func _draw_lane(lane: String) -> void:
	var path := get_lane_path(GameCatalog.TEAM_PLAYER, lane)
	draw_polyline(path, Color(0.12, 0.10, 0.08, 0.28), 38.0, true)
	draw_polyline(path, Color(0.65, 0.59, 0.43, 0.62), 24.0, true)
	draw_polyline(path, Color(0.95, 0.82, 0.52, 0.22), 2.0, true)


func _get_player_lane_path(lane: String) -> PackedVector2Array:
	match lane:
		GameCatalog.LANE_TOP:
			return PackedVector2Array([
				player_base_position,
				Vector2(-1040.0, 335.0),
				Vector2(-1030.0, -455.0),
				Vector2(-705.0, -610.0),
				Vector2(-125.0, -625.0),
				Vector2(520.0, -610.0),
				Vector2(780.0, -570.0),
				enemy_base_position,
			])
		GameCatalog.LANE_BOTTOM:
			return PackedVector2Array([
				player_base_position,
				Vector2(-620.0, 610.0),
				Vector2(90.0, 625.0),
				Vector2(650.0, 590.0),
				Vector2(1040.0, 345.0),
				Vector2(1030.0, -395.0),
				Vector2(975.0, -455.0),
				enemy_base_position,
			])
		_:
			return PackedVector2Array([
				player_base_position,
				Vector2(-650.0, 365.0),
				Vector2(-340.0, 188.0),
				Vector2(0.0, 0.0),
				Vector2(340.0, -188.0),
				Vector2(650.0, -365.0),
				enemy_base_position,
			])
