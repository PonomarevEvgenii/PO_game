class_name NeutralUnit
extends Actor

@export var leash_radius := 180.0
@export var aggro_radius := 90.0
@export var home_stop_distance := 6.0
@export var unit_id := "neutral_bruiser"

var _home_position := Vector2.ZERO
var _aggro_target: Actor
var _returning_home := false


func _ready() -> void:
	super._ready()
	_home_position = global_position


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if not is_alive():
		velocity = Vector2.ZERO
		return

	if _returning_home:
		_return_home()
		move_and_slide()
		_clamp_to_leash()
		return

	if not _is_valid_aggro_target(_aggro_target):
		_aggro_target = _find_enemy_near_camp(aggro_radius)

	if _aggro_target != null and not _can_keep_aggro(_aggro_target):
		_start_return_home()
	elif _aggro_target != null:
		_fight_aggro_target()
	else:
		_return_home()

	move_and_slide()
	_clamp_to_leash()


func take_damage(amount: float, source: Actor) -> void:
	if source != null and not _returning_home and _can_keep_aggro(source):
		_aggro_target = source
		_returning_home = false

	super.take_damage(amount, source)


func configure_neutral(new_unit_id: String, position: Vector2, new_stats: Dictionary) -> void:
	unit_id = new_unit_id
	global_position = position
	_home_position = position
	_aggro_target = null
	_returning_home = false
	configure(GameCatalog.TEAM_NEUTRAL, GameCatalog.LANE_MIDDLE, new_stats)
	queue_redraw()


func _draw() -> void:
	super._draw()
	match unit_id:
		"neutral_spitter":
			draw_circle(Vector2(draw_radius * 0.55, -draw_radius * 0.55), 3.5, Color(0.55, 0.76, 0.45))
			draw_circle(Vector2(draw_radius * 1.02, -draw_radius * 0.76), 2.0, Color(0.65, 0.95, 0.50))
		"neutral_thrower":
			draw_line(Vector2(-draw_radius * 0.9, -draw_radius * 0.7), Vector2(draw_radius * 0.9, -draw_radius * 1.15), Color(0.35, 0.20, 0.10), 3.0)
			draw_circle(Vector2(draw_radius * 1.05, -draw_radius * 1.2), 3.0, Color(0.26, 0.24, 0.20))
		"neutral_claw":
			draw_line(Vector2(-draw_radius * 0.65, -draw_radius * 0.25), Vector2(-draw_radius * 1.25, -draw_radius * 0.85), Color(0.92, 0.86, 0.65), 2.0)
			draw_line(Vector2(draw_radius * 0.65, -draw_radius * 0.25), Vector2(draw_radius * 1.25, -draw_radius * 0.85), Color(0.92, 0.86, 0.65), 2.0)
		_:
			draw_circle(Vector2(0.0, -draw_radius * 1.25), 3.5, Color(0.45, 0.30, 0.16))


func _return_home() -> void:
	if global_position.distance_to(_home_position) < home_stop_distance:
		global_position = _home_position
		velocity = Vector2.ZERO
		_aggro_target = null
		_returning_home = false
		return

	velocity = global_position.direction_to(_home_position) * get_move_speed()


func _fight_aggro_target() -> void:
	if not _is_valid_aggro_target(_aggro_target):
		_start_return_home()
		return

	var target := _aggro_target as Actor
	if not try_attack(target):
		velocity = global_position.direction_to(target.global_position) * get_move_speed()
	else:
		velocity = Vector2.ZERO


func _start_return_home() -> void:
	_aggro_target = null
	_returning_home = true
	_return_home()


func _is_valid_aggro_target(target) -> bool:
	if target == null or not is_instance_valid(target):
		return false

	var actor := target as Actor
	return actor != null and actor.is_alive() and can_damage(actor)


func _can_keep_aggro(target) -> bool:
	if not _is_valid_aggro_target(target):
		return false

	return global_position.distance_to(_home_position) <= leash_radius


func _find_enemy_near_camp(radius: float) -> Actor:
	var best: Actor = null
	var best_distance_squared := radius * radius

	for node in get_tree().get_nodes_in_group("combat_actor"):
		var actor := node as Actor
		if actor == null or not can_damage(actor):
			continue

		var distance_squared := _home_position.distance_squared_to(actor.global_position)
		if distance_squared < best_distance_squared:
			best = actor
			best_distance_squared = distance_squared

	return best


func _clamp_to_leash() -> void:
	var offset := global_position - _home_position
	if offset.length() <= leash_radius:
		return

	global_position = _home_position + offset.normalized() * leash_radius
	if _aggro_target != null:
		_start_return_home()
