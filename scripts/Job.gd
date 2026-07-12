class_name Job
extends Node

enum Type { NEW_CONNECTION, FAULT, COMPLAINT }

var type: Type
var reward: int
var penalty: int
var deadline: int
var days_remaining: int
var is_assigned: bool = false

func setup(job_type) -> void:
	type = job_type
	match type:
		Type.NEW_CONNECTION:
			reward = randi_range(20_000, 50_000)
			penalty = 0
			deadline = randi_range(3, 5)
		Type.FAULT:
			reward = 0
			penalty = randi_range(5_000, 20_000)
			deadline = randi_range(2, 3)
		Type.COMPLAINT:
			reward = randi_range(5_000, 15_000)
			penalty = randi_range(3_000, 10_000)
			deadline = randi_range(3, 4)
	days_remaining = deadline

func get_label() -> String:
	match type:
		Type.NEW_CONNECTION: return "🟢 Nová přípojka"
		Type.FAULT:          return "🔴 Porucha"
		Type.COMPLAINT:      return "🟡 Reklamace"
	return ""
