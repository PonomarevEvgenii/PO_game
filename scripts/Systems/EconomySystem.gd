class_name EconomySystem
extends Node

signal gold_changed(gold: int)

@export var starting_gold := 160

var gold := 0


func _ready() -> void:
	reset_economy()


func reset_economy() -> void:
	gold = starting_gold
	gold_changed.emit(gold)


func add_gold(amount: int) -> void:
	if amount <= 0:
		return

	gold += amount
	gold_changed.emit(gold)


func try_spend(amount: int) -> bool:
	if amount <= 0:
		return true

	if gold < amount:
		return false

	gold -= amount
	gold_changed.emit(gold)
	return true
