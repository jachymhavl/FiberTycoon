class_name GameManager
extends Node

var money: int = 150_000
var reputation: int = 100
var day: int = 1
var teams_total: int = 2
var teams: Array = []
var job_manager: JobManager
var map_node = null
var action_taken: bool = false

# Materiály
var cable: int = 500
var connectors: int = 30
var cabinets_available: int = 0

# Ceny
var cable_price: int = 200
var connector_price: int = 500
var team_price: int = 150_000
var cabinet_price: int = 80_000
var cable_order_amount: int = 200
var connector_order_amount: int = 20

# Objednávky
var pending_orders: Array = []

func _ready() -> void:
	_setup_teams()
	job_manager = JobManager.new()
	add_child(job_manager)
	job_manager.generate_daily_jobs()
	await get_tree().process_frame
	map_node = get_tree().current_scene.find_child("Map")
	print("FiberTycoon spuštěn")

func _setup_teams() -> void:
	var t1 = Team.new()
	t1.setup("Team 1", Team.Skill.SENIOR)
	teams.append(t1)
	var t2 = Team.new()
	t2.setup("Team 2", Team.Skill.JUNIOR)
	teams.append(t2)

func take_action() -> void:
	action_taken = true

func advance_day() -> void:
	day += 1
	_process_teams()
	_daily_costs()
	_collect_income()
	_process_orders()
	var expired = job_manager.process_day()
	_process_expired_jobs(expired)
	job_manager.generate_daily_jobs()
	trigger_random_events()
	_penalize_unresolved_houses()
	action_taken = false
	print("Den: ", day, " | Peníze: ", money, " Kč | Reputace: ", reputation, " %")

func _process_teams() -> void:
	for team in teams:
		if team.is_busy:
			team.days_until_free -= 1
			if team.days_until_free <= 0:
				team.is_busy = false

func _daily_costs() -> void:
	var team_salary = teams.size() * 8_000
	money -= team_salary
	print("Denní náklady: platy týmů ", team_salary, " Kč")

func _collect_income() -> void:
	var map = get_tree().current_scene.find_child("Map")
	if map == null:
		return
	var income = 0
	for house in map.houses:
		if house["connected"] and house["status"] == "connected":
			income += 5_000
	if income > 0:
		money += income
		print("Denní příjem: +", income, " Kč")

func _process_orders() -> void:
	var delivered: Array = []
	for order in pending_orders:
		order["days"] -= 1
		if order["days"] <= 0:
			match order["type"]:
				"cable":
					cable += cable_order_amount
					print("Dodávka kabelu: +", cable_order_amount, "m")
				"connectors":
					connectors += connector_order_amount
					print("Dodávka konektorů: +", connector_order_amount, " ks")
				"cabinet":
					cabinets_available += 1
					print("Nový rozvaděč dorazil!")
			delivered.append(order)
	for order in delivered:
		pending_orders.erase(order)

func _process_expired_jobs(expired: Array) -> void:
	for job in expired:
		money -= job.penalty
		match job.type:
			Job.Type.FAULT:
				reputation -= 10
				print("Porucha neřešena! Pokuta: ", job.penalty, " Kč, Reputace -10")
			Job.Type.COMPLAINT:
				reputation -= 5
				print("Reklamace neřešena! Pokuta: ", job.penalty, " Kč, Reputace -5")
			Job.Type.NEW_CONNECTION:
				reputation -= 2
				print("Přípojka nestihnuta! Reputace -2")

func _penalize_unresolved_houses() -> void:
	var map = get_tree().current_scene.find_child("Map")
	if map == null:
		return
	for house in map.houses:
		if house["status"] == "fault":
			reputation -= 1
			money -= 5_000
		elif house["status"] == "complaint":
			reputation -= 1
			money -= 3_000
	if reputation < 0:
		reputation = 0

func assign_team_to_job(job) -> bool:
	if cable < 20:
		print("Nedostatek kabelu na opravu!")
		return false
	if connectors < 2:
		print("Nedostatek konektorů na opravu!")
		return false
	for team in teams:
		if not team.is_busy:
			job_manager.assign_job(job, team)
			cable -= 20
			connectors -= 2
			return true
	return false

func assign_team_to_job_from_map() -> bool:
	if cable < 50:
		print("Nedostatek kabelu! Potřeba: 50m, máš: ", cable, "m")
		return false
	if connectors < 2:
		print("Nedostatek konektorů! Potřeba: 2, máš: ", connectors)
		return false
	for team in teams:
		if not team.is_busy:
			team.is_busy = true
			team.days_until_free = 1
			cable -= 50
			connectors -= 2
			money += 30_000
			return true
	return false

func buy_team() -> bool:
	if money < team_price:
		print("Nedostatek peněz na nový tým!")
		return false
	money -= team_price
	teams_total += 1
	var t = Team.new()
	t.setup("Team " + str(teams_total), Team.Skill.JUNIOR)
	teams.append(t)
	print("Nový tým najat: Team ", teams_total)
	return true

func order_cable() -> bool:
	var cost = cable_order_amount * cable_price
	if money < cost:
		print("Nedostatek peněz na kabel!")
		return false
	money -= cost
	pending_orders.append({"type": "cable", "days": 2})
	print("Objednán kabel: ", cable_order_amount, "m, dorazí za 2 dny")
	return true

func order_connectors() -> bool:
	var cost = connector_order_amount * connector_price
	if money < cost:
		print("Nedostatek peněz na konektory!")
		return false
	money -= cost
	pending_orders.append({"type": "connectors", "days": 2})
	print("Objednány konektory: ", connector_order_amount, " ks, dorazí za 2 dny")
	return true

func buy_cabinet() -> bool:
	if money < cabinet_price:
		print("Nedostatek peněz na rozvaděč!")
		return false
	money -= cabinet_price
	pending_orders.append({"type": "cabinet", "days": 3})
	print("Objednán rozvaděč, dorazí za 3 dny")
	return true

func place_cabinet() -> bool:
	if cabinets_available <= 0:
		print("Nemáš žádný rozvaděč k umístění!")
		return false
	return true

func use_cabinet() -> void:
	cabinets_available -= 1

func trigger_random_events() -> void:
	var map = get_tree().current_scene.find_child("Map")
	if map == null:
		return
	for i in range(map.houses.size()):
		var house = map.houses[i]
		if house["connected"] and house["status"] == "connected":
			var roll = randf()
			if roll < 0.1:
				map.set_house_status(i, "fault")
				var job = Job.new()
				job.setup(Job.Type.FAULT)
				job_manager.active_jobs.append(job)
				print("PORUCHA na domě ", i, "!")
			elif roll < 0.15:
				map.set_house_status(i, "complaint")
				var job = Job.new()
				job.setup(Job.Type.COMPLAINT)
				job_manager.active_jobs.append(job)
				print("REKLAMACE na domě ", i, "!")
