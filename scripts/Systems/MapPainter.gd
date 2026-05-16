class_name MapPainter
extends Node2D

const MAP_RECT := Rect2(Vector2(-1200.0, -780.0), Vector2(2400.0, 1560.0))

var _lane_manager: LaneManager


func _ready() -> void:
	_lane_manager = get_parent().get_node_or_null("LaneManager") as LaneManager
	z_index = -100
	queue_redraw()


func _draw() -> void:
	_draw_ground()
	_draw_terrain_noise()
	_draw_river()
	_draw_lane_roads()
	_draw_cliffs_and_walls()
	_draw_jungle()
	_draw_bases()
	_draw_neutral_camps()
	_draw_lane_markers()


func _draw_ground() -> void:
	draw_rect(MAP_RECT, Color(0.34, 0.38, 0.26))
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-1200.0, 780.0),
			Vector2(-1200.0, 145.0),
			Vector2(-815.0, 340.0),
			Vector2(-410.0, 280.0),
			Vector2(-135.0, 430.0),
			Vector2(110.0, 780.0),
		]),
		Color(0.28, 0.48, 0.22)
	)
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(1200.0, -780.0),
			Vector2(1200.0, -145.0),
			Vector2(815.0, -340.0),
			Vector2(410.0, -280.0),
			Vector2(135.0, -430.0),
			Vector2(-110.0, -780.0),
		]),
		Color(0.42, 0.36, 0.24)
	)
	draw_rect(MAP_RECT, Color(0.02, 0.025, 0.025, 0.18), false, 8.0)


func _draw_terrain_noise() -> void:
	for i in range(230):
		var x := -1160.0 + float((i * 97) % 2320)
		var y := -740.0 + float((i * 53) % 1480)
		var size := 3.0 + float((i * 7) % 9)
		var color := Color(0.45, 0.42, 0.29, 0.22) if i % 2 == 0 else Color(0.20, 0.31, 0.18, 0.22)
		draw_rect(Rect2(Vector2(x, y), Vector2(size, 2.0)), color)

	for i in range(72):
		var x := -1110.0 + float((i * 181) % 2220)
		var y := -710.0 + float((i * 113) % 1420)
		_draw_rock(Vector2(x, y), 0.65 + float(i % 3) * 0.18)


func _draw_river() -> void:
	var river := PackedVector2Array([
		Vector2(-1180.0, -230.0),
		Vector2(-850.0, -160.0),
		Vector2(-520.0, -118.0),
		Vector2(-235.0, -44.0),
		Vector2(0.0, 0.0),
		Vector2(250.0, 46.0),
		Vector2(560.0, 115.0),
		Vector2(870.0, 178.0),
		Vector2(1180.0, 250.0),
	])
	draw_polyline(river, Color(0.17, 0.23, 0.24), 92.0, true)
	draw_polyline(river, Color(0.27, 0.39, 0.39), 68.0, true)
	draw_polyline(river, Color(0.39, 0.52, 0.49, 0.45), 10.0, true)

	for bridge in [Vector2(-1035.0, -190.0), Vector2(0.0, 0.0), Vector2(1035.0, 215.0)]:
		_draw_bridge(bridge)


func _draw_lane_roads() -> void:
	if _lane_manager == null:
		return

	for lane in [GameCatalog.LANE_TOP, GameCatalog.LANE_MIDDLE, GameCatalog.LANE_BOTTOM]:
		var path := _lane_manager.get_lane_path(GameCatalog.TEAM_PLAYER, lane)
		draw_polyline(path, Color(0.15, 0.13, 0.10, 0.35), 48.0, true)
		draw_polyline(path, Color(0.62, 0.55, 0.39), 34.0, true)
		draw_polyline(path, Color(0.79, 0.72, 0.52, 0.24), 4.0, true)


func _draw_cliffs_and_walls() -> void:
	for pos in [
		Vector2(-830.0, -470.0), Vector2(-780.0, -470.0), Vector2(-730.0, -470.0),
		Vector2(-635.0, 175.0), Vector2(-585.0, 175.0), Vector2(-535.0, 175.0),
		Vector2(-350.0, 420.0), Vector2(-300.0, 420.0), Vector2(-250.0, 420.0),
		Vector2(350.0, -420.0), Vector2(300.0, -420.0), Vector2(250.0, -420.0),
		Vector2(635.0, -175.0), Vector2(585.0, -175.0), Vector2(535.0, -175.0),
		Vector2(830.0, 470.0), Vector2(780.0, 470.0), Vector2(730.0, 470.0),
		Vector2(-110.0, -285.0), Vector2(-60.0, -285.0), Vector2(60.0, 285.0), Vector2(110.0, 285.0),
	]:
		_draw_wall_piece(pos)


func _draw_jungle() -> void:
	_draw_tree_cluster(Vector2(-810.0, 40.0), 42, 240.0, 170.0)
	_draw_tree_cluster(Vector2(-620.0, -300.0), 34, 230.0, 155.0)
	_draw_tree_cluster(Vector2(-405.0, 345.0), 30, 205.0, 150.0)
	_draw_tree_cluster(Vector2(-80.0, 470.0), 24, 180.0, 130.0)
	_draw_tree_cluster(Vector2(-115.0, -430.0), 26, 185.0, 130.0)
	_draw_tree_cluster(Vector2(810.0, -40.0), 42, 240.0, 170.0)
	_draw_tree_cluster(Vector2(620.0, 300.0), 34, 230.0, 155.0)
	_draw_tree_cluster(Vector2(405.0, -345.0), 30, 205.0, 150.0)
	_draw_tree_cluster(Vector2(80.0, -470.0), 24, 180.0, 130.0)
	_draw_tree_cluster(Vector2(115.0, 430.0), 26, 185.0, 130.0)


func _draw_bases() -> void:
	_draw_base_ground(Vector2(-900.0, 520.0), true)
	_draw_base_ground(Vector2(900.0, -520.0), false)
	if _lane_manager != null:
		for tower_position in _lane_manager.get_lane_tower_positions(GameCatalog.TEAM_PLAYER):
			_draw_tower(tower_position, true)
		for tower_position in _lane_manager.get_lane_tower_positions(GameCatalog.TEAM_ENEMY):
			_draw_tower(tower_position, false)


func _draw_neutral_camps() -> void:
	for camp in _neutral_camp_positions():
		draw_circle(camp, 42.0, Color(0.16, 0.12, 0.08, 0.36))
		draw_arc(camp, 45.0, 0.0, TAU, 24, Color(0.73, 0.62, 0.37, 0.48), 2.0)
		draw_line(camp + Vector2(-13.0, 0.0), camp + Vector2(13.0, 0.0), Color(0.55, 0.40, 0.19, 0.5), 2.0)


func _neutral_camp_positions() -> Array[Vector2]:
	return [
		Vector2(-770.0, -185.0),
		Vector2(-650.0, 90.0),
		Vector2(-450.0, -360.0),
		Vector2(-320.0, 330.0),
		Vector2(-95.0, -255.0),
		Vector2(-85.0, 445.0),
		Vector2(770.0, 185.0),
		Vector2(650.0, -90.0),
		Vector2(450.0, 360.0),
		Vector2(320.0, -330.0),
		Vector2(95.0, 255.0),
		Vector2(85.0, -445.0),
	]


func _draw_lane_markers() -> void:
	if _lane_manager == null:
		return

	for lane in [GameCatalog.LANE_TOP, GameCatalog.LANE_MIDDLE, GameCatalog.LANE_BOTTOM]:
		var path := _lane_manager.get_lane_path(GameCatalog.TEAM_PLAYER, lane)
		for i in range(1, path.size() - 1):
			_draw_banner(path[i], i % 2 == 0)


func _draw_base_ground(center: Vector2, player_side: bool) -> void:
	var color := Color(0.34, 0.44, 0.27) if player_side else Color(0.43, 0.31, 0.25)
	var rect := Rect2(center - Vector2(145.0, 105.0), Vector2(290.0, 210.0))
	draw_rect(rect, Color(0.13, 0.12, 0.10, 0.32))
	draw_rect(rect.grow(-8.0), color)
	draw_rect(rect.grow(-8.0), Color(0.70, 0.68, 0.57, 0.70), false, 5.0)
	_draw_tower(center + Vector2(-92.0, -64.0), player_side)
	_draw_tower(center + Vector2(92.0, 64.0), player_side)


func _draw_tower(position: Vector2, player_side: bool) -> void:
	var roof := Color(0.24, 0.78, 0.25) if player_side else Color(0.86, 0.23, 0.19)
	draw_rect(Rect2(position - Vector2(15.0, 18.0), Vector2(30.0, 36.0)), Color(0.42, 0.38, 0.29))
	draw_colored_polygon(PackedVector2Array([position + Vector2(-20.0, -17.0), position + Vector2(20.0, -17.0), position + Vector2(0.0, -38.0)]), roof)
	draw_rect(Rect2(position - Vector2(15.0, 18.0), Vector2(30.0, 36.0)), Color.BLACK, false, 2.0)


func _draw_tree_cluster(center: Vector2, count: int, width: float, height: float) -> void:
	for i in range(count):
		var x := center.x - width * 0.5 + float((i * 47) % int(width))
		var y := center.y - height * 0.5 + float((i * 31) % int(height))
		var scale := 0.75 + float(i % 4) * 0.12
		_draw_tree(Vector2(x, y), scale, i % 3 == 0)


func _draw_tree(position: Vector2, scale: float, dark: bool) -> void:
	var trunk := Color(0.25, 0.16, 0.09)
	var leaf := Color(0.12, 0.28, 0.14) if dark else Color(0.18, 0.37, 0.16)
	draw_rect(Rect2(position + Vector2(-3.0, 7.0) * scale, Vector2(6.0, 10.0) * scale), trunk)
	draw_colored_polygon(PackedVector2Array([
		position + Vector2(-16.0, 7.0) * scale,
		position + Vector2(16.0, 7.0) * scale,
		position + Vector2(0.0, -22.0) * scale,
	]), leaf)
	draw_colored_polygon(PackedVector2Array([
		position + Vector2(-12.0, -4.0) * scale,
		position + Vector2(12.0, -4.0) * scale,
		position + Vector2(0.0, -28.0) * scale,
	]), leaf.lightened(0.08))


func _draw_wall_piece(position: Vector2) -> void:
	draw_rect(Rect2(position - Vector2(23.0, 10.0), Vector2(46.0, 20.0)), Color(0.32, 0.31, 0.27))
	draw_rect(Rect2(position - Vector2(23.0, 10.0), Vector2(46.0, 20.0)), Color(0.13, 0.12, 0.10), false, 2.0)
	draw_line(position + Vector2(-18.0, -2.0), position + Vector2(18.0, -2.0), Color(0.46, 0.44, 0.38), 2.0)


func _draw_bridge(position: Vector2) -> void:
	draw_rect(Rect2(position - Vector2(45.0, 13.0), Vector2(90.0, 26.0)), Color(0.38, 0.25, 0.14))
	for i in range(6):
		var x := position.x - 36.0 + float(i) * 14.0
		draw_line(Vector2(x, position.y - 12.0), Vector2(x, position.y + 12.0), Color(0.20, 0.13, 0.08), 2.0)
	draw_rect(Rect2(position - Vector2(45.0, 13.0), Vector2(90.0, 26.0)), Color(0.08, 0.06, 0.04), false, 2.0)


func _draw_rock(position: Vector2, scale: float) -> void:
	draw_colored_polygon(PackedVector2Array([
		position + Vector2(-9.0, 7.0) * scale,
		position + Vector2(-2.0, -8.0) * scale,
		position + Vector2(9.0, -3.0) * scale,
		position + Vector2(12.0, 8.0) * scale,
	]), Color(0.23, 0.23, 0.20, 0.65))


func _draw_banner(position: Vector2, player_side: bool) -> void:
	var flag_color := Color(0.20, 0.76, 0.22) if player_side else Color(0.83, 0.22, 0.18)
	draw_line(position + Vector2(0.0, -22.0), position + Vector2(0.0, 8.0), Color(0.12, 0.08, 0.05), 2.0)
	draw_colored_polygon(PackedVector2Array([
		position + Vector2(0.0, -22.0),
		position + Vector2(18.0, -16.0),
		position + Vector2(0.0, -10.0),
	]), flag_color)
