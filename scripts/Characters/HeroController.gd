class_name HeroController
extends Actor

@export var ability_caster_path: NodePath = NodePath("AbilityCaster")

var hero_id := GameCatalog.DEFAULT_HERO_ID
var _ability_caster: AbilityCaster


func _ready() -> void:
	super._ready()
	_ability_caster = get_node_or_null(ability_caster_path) as AbilityCaster


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if not is_alive():
		velocity = Vector2.ZERO
		return

	var input := Vector2.ZERO
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		input.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		input.y += 1.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		input.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		input.x += 1.0

	velocity = input.normalized() * get_move_speed() if input.length_squared() > 0.0 else Vector2.ZERO

	if velocity == Vector2.ZERO:
		try_attack(find_nearest_enemy(_stat("attack_range")))

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if not is_alive() or _ability_caster == null:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		var mouse_position := get_global_mouse_position()
		if event.keycode == KEY_1:
			_ability_caster.cast(0, mouse_position)
		elif event.keycode == KEY_2:
			_ability_caster.cast(1, mouse_position)
		elif event.keycode == KEY_3:
			_ability_caster.cast(2, mouse_position)
		elif event.keycode == KEY_4:
			_ability_caster.cast(3, mouse_position)


func configure_hero(definition: Dictionary) -> void:
	if definition.is_empty():
		return

	hero_id = String(definition.get("id", GameCatalog.DEFAULT_HERO_ID))
	configure(GameCatalog.TEAM_PLAYER, GameCatalog.LANE_MIDDLE, definition.get("stats", {}))

	_ability_caster = get_node_or_null(ability_caster_path) as AbilityCaster
	if _ability_caster != null:
		_ability_caster.set_abilities(definition.get("abilities", []))


func get_abilities() -> Array:
	if _ability_caster == null:
		return []

	return _ability_caster.abilities


func _draw() -> void:
	draw_arc(Vector2.ZERO, draw_radius + 8.0, 0.0, TAU, 36, Color(0.95, 0.84, 0.32, 0.85), 2.5)
	super._draw()
	draw_circle(Vector2(0.0, -draw_radius * 1.42), 3.0, Color(1.0, 0.92, 0.45))
