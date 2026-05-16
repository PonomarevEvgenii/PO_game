class_name HeroSelectController
extends Control

signal hero_chosen(hero_id: String)
signal back_requested


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	var background := ColorRect.new()
	background.color = Color(0.09, 0.10, 0.12)
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	add_child(background)

	var margin := MarginContainer.new()
	margin.anchor_right = 1.0
	margin.anchor_bottom = 1.0
	margin.add_theme_constant_override("margin_left", 42)
	margin.add_theme_constant_override("margin_right", 42)
	margin.add_theme_constant_override("margin_top", 36)
	margin.add_theme_constant_override("margin_bottom", 36)
	add_child(margin)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 16)
	margin.add_child(root)

	var title := Label.new()
	title.text = "Choose Hero"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	root.add_child(title)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 16)
	grid.add_theme_constant_override("v_separation", 16)
	root.add_child(grid)

	for hero in GameCatalog.create_hero_definitions().values():
		var button := Button.new()
		button.text = "%s\n%s\n%s" % [hero.get("display_name", ""), hero.get("description", ""), _ability_line(hero.get("abilities", []))]
		button.custom_minimum_size = Vector2(420.0, 118.0)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var hero_id := String(hero.get("id", GameCatalog.DEFAULT_HERO_ID))
		button.pressed.connect(_choose_hero.bind(hero_id))
		grid.add_child(button)

	var back_button := Button.new()
	back_button.text = "Back"
	back_button.custom_minimum_size = Vector2(160.0, 42.0)
	back_button.pressed.connect(func() -> void: back_requested.emit())
	root.add_child(back_button)


func _choose_hero(hero_id: String) -> void:
	hero_chosen.emit(hero_id)


func _ability_line(abilities: Array) -> String:
	var names: Array[String] = []
	for ability in abilities:
		names.append(String(ability.get("display_name", "")))

	return "Skills: %s" % ", ".join(names)
