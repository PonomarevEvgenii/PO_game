class_name ShopSystem
extends Node

signal unit_upgraded(unit_id: String, level: int)

var _upgrade_levels := {}
var _economy: EconomySystem


func bind(economy: EconomySystem) -> void:
	_economy = economy


func get_upgrade_level(unit_id: String) -> int:
	return int(_upgrade_levels.get(unit_id, 0))


func get_next_upgrade_cost(definition: Dictionary) -> int:
	var next_level := get_upgrade_level(String(definition.get("id", ""))) + 1
	return int(definition.get("upgrade_cost", 0)) * next_level


func buy_unit_upgrade(unit_id: String) -> bool:
	var definitions := GameCatalog.create_unit_definitions()
	if not definitions.has(unit_id):
		return false

	var definition: Dictionary = definitions[unit_id]
	if not bool(definition.get("is_lane_unit", false)):
		return false

	var cost := get_next_upgrade_cost(definition)
	if _economy == null or not _economy.try_spend(cost):
		return false

	var level := get_upgrade_level(unit_id) + 1
	_upgrade_levels[unit_id] = level
	unit_upgraded.emit(unit_id, level)
	return true
