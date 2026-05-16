class_name MinimapView
extends Control


func _ready() -> void:
	custom_minimum_size = Vector2(150.0, 118.0)
	queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	draw_rect(rect, Color(0.08, 0.10, 0.08))
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, size.y),
		Vector2(0.0, size.y * 0.54),
		Vector2(size.x * 0.42, size.y * 0.72),
		Vector2(size.x * 0.54, size.y),
	]), Color(0.18, 0.42, 0.16))
	draw_colored_polygon(PackedVector2Array([
		Vector2(size.x, 0.0),
		Vector2(size.x, size.y * 0.46),
		Vector2(size.x * 0.58, size.y * 0.28),
		Vector2(size.x * 0.46, 0.0),
	]), Color(0.40, 0.28, 0.20))

	var river := PackedVector2Array([
		Vector2(0.0, size.y * 0.36),
		Vector2(size.x * 0.34, size.y * 0.44),
		Vector2(size.x * 0.51, size.y * 0.50),
		Vector2(size.x * 0.72, size.y * 0.58),
		Vector2(size.x, size.y * 0.68),
	])
	draw_polyline(river, Color(0.26, 0.44, 0.45), 9.0, true)

	_draw_mini_lane(PackedVector2Array([
		_to_mini(Vector2(-900.0, 520.0)),
		_to_mini(Vector2(-1040.0, 335.0)),
		_to_mini(Vector2(-1030.0, -455.0)),
		_to_mini(Vector2(-705.0, -610.0)),
		_to_mini(Vector2(520.0, -610.0)),
		_to_mini(Vector2(900.0, -520.0)),
	]))
	_draw_mini_lane(PackedVector2Array([
		_to_mini(Vector2(-900.0, 520.0)),
		_to_mini(Vector2(-340.0, 188.0)),
		_to_mini(Vector2(0.0, 0.0)),
		_to_mini(Vector2(340.0, -188.0)),
		_to_mini(Vector2(900.0, -520.0)),
	]))
	_draw_mini_lane(PackedVector2Array([
		_to_mini(Vector2(-900.0, 520.0)),
		_to_mini(Vector2(-620.0, 610.0)),
		_to_mini(Vector2(650.0, 590.0)),
		_to_mini(Vector2(1030.0, -395.0)),
		_to_mini(Vector2(900.0, -520.0)),
	]))

	for camp in [
		Vector2(-770.0, -185.0), Vector2(-650.0, 90.0), Vector2(-450.0, -360.0),
		Vector2(-320.0, 330.0), Vector2(-95.0, -255.0), Vector2(-85.0, 445.0),
		Vector2(770.0, 185.0), Vector2(650.0, -90.0), Vector2(450.0, 360.0),
		Vector2(320.0, -330.0), Vector2(95.0, 255.0), Vector2(85.0, -445.0),
	]:
		draw_circle(_to_mini(camp), 1.8, Color(0.78, 0.64, 0.34))

	draw_circle(_to_mini(Vector2(-900.0, 520.0)), 5.5, Color(0.20, 0.85, 0.25))
	draw_circle(_to_mini(Vector2(900.0, -520.0)), 5.5, Color(0.90, 0.20, 0.18))
	draw_rect(rect, Color(0.72, 0.65, 0.48), false, 2.0)


func _draw_mini_lane(points: PackedVector2Array) -> void:
	draw_polyline(points, Color(0.73, 0.64, 0.42), 2.0, true)


func _to_mini(world: Vector2) -> Vector2:
	return Vector2(
		(world.x + 1200.0) / 2400.0 * size.x,
		(world.y + 780.0) / 1560.0 * size.y
	)
