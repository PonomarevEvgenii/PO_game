class_name EnemyHeroAi
extends Actor

@export var objective_position := Vector2.ZERO
@export var aggro_range := 260.0


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if not is_alive():
		velocity = Vector2.ZERO
		return

	var target := find_nearest_enemy(aggro_range)
	if target != null:
		if not try_attack(target):
			_move_toward(target.global_position)
		else:
			velocity = Vector2.ZERO
	else:
		_move_toward(objective_position)

	move_and_slide()


func _move_toward(point: Vector2) -> void:
	if global_position.distance_to(point) < 8.0:
		velocity = Vector2.ZERO
		return

	velocity = global_position.direction_to(point) * get_move_speed()
