class_name Team
extends Resource

enum Skill { JUNIOR, SENIOR }

var team_name: String 
var skill: Skill 
var is_busy: bool = false 
var days_until_free: int = 0
var complaint_chance: float

func setup(p_name: String, team_skill: Skill) -> void:
	team_name = p_name
	skill = team_skill
	match skill:
		Skill.JUNIOR:
			complaint_chance = 0.4
		Skill.SENIOR:
			complaint_chance = 0.1

func get_label() -> String:
	if is_busy:
		return "%s — zaneprázdněn (%d dní)" % [team_name, days_until_free]
	return "%s — volný" % team_name
