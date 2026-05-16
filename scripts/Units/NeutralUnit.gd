class_name NeutralUnit
extends Actor

@export var leash_radius := 180.0
@export var unit_id := "neutral_bruiser"

var _home_position := Vector2.ZERO
var _aggro_target: Actor


func _ready() -> void:
	super._ready()
	_home_position = global_position


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if not is_alive():
		velocity = Vector2.ZERO
		return

	if _aggro_target == null or not is_instance_valid(_aggro_target) or not _aggro_target.is_alive():
		_aggro_target = find_nearest_enemy(90.0)

	if _aggro_target != null and global_position.distance_to(_home_position) <= leash_radius:
		if not try_attack(_aggro_target):
			velocity = global_position.direction_to(_aggro_target.global_position) * get_move_speed()
		else:
			velocity = Vector2.ZERO
	else:
		_return_home()

	move_and_slide()


func take_damage(amount: float, source: Actor) -> void:
	if source != null:
		_aggro_target = source

	super.take_damage(amount, source)


func configure_neutral(new_unit_id: String, position: Vector2, new_stats: Dictionary) -> void:
	unit_id = new_unit_id
	global_position = position
	_home_position = position
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
	if global_position.distance_to(_home_position) < 6.0:
		velocity = Vector2.ZERO
		_aggro_target = null
		return

	velocity = global_position.direction_to(_home_position) * get_move_speed()
