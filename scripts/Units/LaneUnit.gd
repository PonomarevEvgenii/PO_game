class_name LaneUnit
extends Actor

@export var lane_target := Vector2.ZERO
@export var unit_id := "line_melee"

var lane_path := PackedVector2Array()
var _waypoint_index := 1


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if not is_alive():
		velocity = Vector2.ZERO
		return

	var enemy := find_nearest_enemy(_stat("attack_range"))
	if enemy != null:
		velocity = Vector2.ZERO
		try_attack(enemy)
	else:
		_move_along_lane()

	move_and_slide()


func configure_lane_unit(new_unit_id: String, new_team: String, new_lane: String, path: PackedVector2Array, new_stats: Dictionary) -> void:
	unit_id = new_unit_id
	lane_path = path
	_waypoint_index = 1
	global_position = lane_path[0] if lane_path.size() > 0 else Vector2.ZERO
	lane_target = lane_path[lane_path.size() - 1] if lane_path.size() > 0 else Vector2.ZERO
	configure(new_team, new_lane, new_stats)
	queue_redraw()


func _draw() -> void:
	super._draw()
	match unit_id:
		"line_mage":
			draw_circle(Vector2(0.0, -draw_radius * 1.2), 3.0, Color(0.55, 0.80, 1.0))
			draw_line(Vector2(draw_radius * 0.7, -draw_radius * 0.45), Vector2(draw_radius * 1.35, -draw_radius * 1.1), Color(0.65, 0.48, 0.25), 2.0)
		"line_siege":
			draw_rect(Rect2(Vector2(-draw_radius * 1.2, -draw_radius * 0.35), Vector2(draw_radius * 2.4, draw_radius * 1.15)), Color(0.31, 0.22, 0.13))
			draw_circle(Vector2(-draw_radius * 0.85, draw_radius * 0.75), 3.0, Color(0.06, 0.05, 0.04))
			draw_circle(Vector2(draw_radius * 0.85, draw_radius * 0.75), 3.0, Color(0.06, 0.05, 0.04))
		_:
			draw_line(Vector2(draw_radius * 0.55, -draw_radius * 0.45), Vector2(draw_radius * 1.25, -draw_radius * 1.25), Color(0.72, 0.72, 0.62), 2.0)


func _move_along_lane() -> void:
	if lane_path.is_empty() or _waypoint_index >= lane_path.size():
		velocity = Vector2.ZERO
		return

	var target := lane_path[_waypoint_index]
	if global_position.distance_to(target) < 12.0:
		_waypoint_index += 1
		if _waypoint_index >= lane_path.size():
			velocity = Vector2.ZERO
			return

		target = lane_path[_waypoint_index]

	velocity = global_position.direction_to(target) * get_move_speed()
