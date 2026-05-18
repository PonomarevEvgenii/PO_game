class_name SummonedCompanion
extends Actor

@export var companion_kind := "wolf"
@export var lifetime := 18.0
@export var aggro_range := 180.0

var owner_actor: Actor
var target_actor: Actor
var objective_position := Vector2.ZERO


func _ready() -> void:
	super._ready()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
		return

	if not is_alive():
		velocity = Vector2.ZERO
		return

	var target := _choose_target()
	if target != null:
		if not try_attack(target):
			velocity = global_position.direction_to(target.global_position) * get_move_speed()
		else:
			velocity = Vector2.ZERO
	elif objective_position != Vector2.ZERO and global_position.distance_to(objective_position) > 12.0:
		velocity = global_position.direction_to(objective_position) * get_move_speed()
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func configure_companion(kind: String, owner: Actor, position: Vector2, new_stats: Dictionary, target: Actor = null, objective: Vector2 = Vector2.ZERO, lifetime_override: float = 0.0) -> void:
	companion_kind = kind
	owner_actor = owner
	target_actor = target
	objective_position = objective
	global_position = position
	configure(owner.team if owner != null else GameCatalog.TEAM_PLAYER, GameCatalog.LANE_MIDDLE, new_stats)

	match companion_kind:
		"treant":
			draw_radius = 15.0
			lifetime = 30.0
			aggro_range = 150.0
		"snake":
			draw_radius = 7.0
			lifetime = 60.0
			aggro_range = 260.0
		_:
			draw_radius = 10.0
			lifetime = 22.0
			aggro_range = 170.0

	if lifetime_override > 0.0:
		lifetime = lifetime_override

	queue_redraw()


func _choose_target() -> Actor:
	if target_actor != null and is_instance_valid(target_actor) and can_damage(target_actor):
		return target_actor

	if companion_kind == "snake" and target_actor != null:
		queue_free()
		return null

	return find_nearest_enemy(aggro_range)


func _draw() -> void:
	super._draw()
	match companion_kind:
		"treant":
			draw_rect(Rect2(Vector2(-5.0, -18.0), Vector2(10.0, 26.0)), Color(0.29, 0.17, 0.08))
			draw_circle(Vector2(0.0, -20.0), 10.0, Color(0.12, 0.35, 0.13))
		"snake":
			draw_arc(Vector2.ZERO, draw_radius + 5.0, -0.4, 3.8, 18, Color(0.40, 0.74, 0.25), 4.0)
			draw_circle(Vector2(draw_radius + 3.0, -2.0), 3.0, Color(0.55, 0.95, 0.32))
		_:
			draw_line(Vector2(-draw_radius, -draw_radius * 0.2), Vector2(-draw_radius * 1.55, -draw_radius * 0.9), Color(0.85, 0.85, 0.68), 2.0)
			draw_line(Vector2(draw_radius, -draw_radius * 0.2), Vector2(draw_radius * 1.55, -draw_radius * 0.9), Color(0.85, 0.85, 0.68), 2.0)
