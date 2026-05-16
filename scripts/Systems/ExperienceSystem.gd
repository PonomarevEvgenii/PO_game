class_name ExperienceSystem
extends Node

signal experience_changed(level: int, experience: int, required_experience: int)

@export var base_required_experience := 40

var level := 1
var experience := 0


func _ready() -> void:
	reset_progress()


func required_experience() -> int:
	return base_required_experience + (level - 1) * 30


func reset_progress() -> void:
	level = 1
	experience = 0
	experience_changed.emit(level, experience, required_experience())


func add_experience(amount: int) -> void:
	if amount <= 0:
		return

	experience += amount

	while experience >= required_experience():
		experience -= required_experience()
		level += 1

	experience_changed.emit(level, experience, required_experience())
