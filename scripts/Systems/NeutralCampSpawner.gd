class_name NeutralCampSpawner
extends Node

signal unit_spawned(actor: Actor)

var _actor_parent: Node2D
var _neutral_unit_scene: PackedScene


func configure(actor_parent: Node2D, neutral_unit_scene: PackedScene) -> void:
	_actor_parent = actor_parent
	_neutral_unit_scene = neutral_unit_scene


func spawn_initial_camps() -> void:
	if _actor_parent == null or _neutral_unit_scene == null:
		return

	_spawn_camp(Vector2(-770.0, -185.0), ["neutral_bruiser", "neutral_spitter"])
	_spawn_camp(Vector2(-650.0, 90.0), ["neutral_thrower", "neutral_bruiser"])
	_spawn_camp(Vector2(-450.0, -360.0), ["neutral_claw", "neutral_spitter"])
	_spawn_camp(Vector2(-320.0, 330.0), ["neutral_bruiser", "neutral_thrower", "neutral_spitter"])
	_spawn_camp(Vector2(-95.0, -255.0), ["neutral_claw", "neutral_bruiser"])
	_spawn_camp(Vector2(-85.0, 445.0), ["neutral_spitter", "neutral_thrower"])

	_spawn_camp(Vector2(770.0, 185.0), ["neutral_bruiser", "neutral_spitter"])
	_spawn_camp(Vector2(650.0, -90.0), ["neutral_thrower", "neutral_bruiser"])
	_spawn_camp(Vector2(450.0, 360.0), ["neutral_claw", "neutral_spitter"])
	_spawn_camp(Vector2(320.0, -330.0), ["neutral_bruiser", "neutral_thrower", "neutral_spitter"])
	_spawn_camp(Vector2(95.0, 255.0), ["neutral_claw", "neutral_bruiser"])
	_spawn_camp(Vector2(85.0, -445.0), ["neutral_spitter", "neutral_thrower"])


func _spawn_camp(center: Vector2, unit_ids: Array[String]) -> void:
	var offsets := [
		Vector2(-18.0, -10.0),
		Vector2(20.0, -6.0),
		Vector2(0.0, 22.0),
	]

	for i in range(unit_ids.size()):
		_spawn_neutral(unit_ids[i], center + offsets[i % offsets.size()])


func _spawn_neutral(unit_id: String, position: Vector2) -> void:
	var definitions := GameCatalog.create_unit_definitions()
	if not definitions.has(unit_id):
		return

	var definition: Dictionary = definitions[unit_id]
	var unit := _neutral_unit_scene.instantiate() as NeutralUnit
	_actor_parent.add_child(unit)
	unit.configure_neutral(unit_id, position, definition.get("stats", {}).duplicate(true))
	unit_spawned.emit(unit)
