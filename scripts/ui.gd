extends CanvasLayer

@onready var money_label = $StatsPanel/money_label
@onready var reputation_label = $StatsPanel/reputation_label
@onready var day_label = $StatsPanel/day_label
@onready var teams_label = $StatsPanel/teams_label
@onready var next_day_button = $StatsPanel/next_day
@onready var jobs_panel = $StatsPanel/jobs_panel
@onready var jobs_header = $StatsPanel/jobs_panel/jobs_header
@onready var teams_panel = $StatsPanel/teams_panel
@onready var teams_header = $StatsPanel/teams_panel/teams_header

var material_label: Label
var upgrades_panel: VBoxContainer
var stats_ref

func _ready() -> void:
	var bg = ColorRect.new()
	bg.color = Color(0.12, 0.12, 0.15, 0.95)
	bg.size = Vector2(586, 959)
	bg.position = Vector2(1120, 0)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.z_index = -10
	add_child(bg)
	move_child(bg, 0)
	var scroll = ScrollContainer.new()
	scroll.position = Vector2(1130, 5)
	scroll.size = Vector2(560, 940)
	add_child(scroll)
	var stats = $StatsPanel
	stats.get_parent().remove_child(stats)
	scroll.add_child(stats)
	stats.position = Vector2(0, 0)
	stats.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stats_ref = stats
	next_day_button.pressed.connect(_on_next_day_pressed)
	next_day_button.text = "📅 Další den"
	next_day_button.disabled = true
	jobs_header.text = "--- AKTIVNÍ ZAKÁZKY ---"
	teams_header.text = "--- TÝMY ---"
	money_label.add_theme_color_override("font_color", Color(0.2, 0.9, 0.3))
	reputation_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.0))
	day_label.add_theme_color_override("font_color", Color(0.5, 0.8, 1.0))
	teams_label.add_theme_color_override("font_color", Color(1.0, 0.5, 0.3))
	material_label = Label.new()
	material_label.add_theme_color_override("font_color", Color(0.8, 0.6, 1.0))
	stats_ref.add_child(material_label)
	_create_upgrades_panel()
	update_stats()
	update_jobs()
	update_teams()

func _create_upgrades_panel() -> void:
	var header = Label.new()
	header.text = "--- UPGRADY ---"
	stats_ref.add_child(header)
	upgrades_panel = VBoxContainer.new()
	stats_ref.add_child(upgrades_panel)
	var btn_team = Button.new()
	btn_team.text = "👷 Nový tým (150k Kč)"
	btn_team.pressed.connect(_on_buy_team)
	upgrades_panel.add_child(btn_team)
	var btn_cable = Button.new()
	btn_cable.text = "🔌 Objednat kabel (40k Kč)"
	btn_cable.pressed.connect(_on_order_cable)
	upgrades_panel.add_child(btn_cable)
	var btn_conn = Button.new()
	btn_conn.text = "🔗 Objednat konektory (10k Kč)"
	btn_conn.pressed.connect(_on_order_connectors)
	upgrades_panel.add_child(btn_conn)
	var btn_cab = Button.new()
	btn_cab.text = "⚡ Koupit rozvaděč (80k Kč)"
	btn_cab.pressed.connect(_on_buy_cabinet)
	upgrades_panel.add_child(btn_cab)

func _on_next_day_pressed() -> void:
	var gm = get_node("/root/Main/GameManager")
	if not gm.action_taken:
		return
	gm.advance_day()
	next_day_button.disabled = true
	update_stats()
	update_jobs()
	update_teams()
	if gm.money <= 0 or gm.reputation <= 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _on_assign_pressed(job) -> void:
	var gm = get_node("/root/Main/GameManager")
	var result = gm.assign_team_to_job(job)
	if result:
		gm.take_action()
		next_day_button.disabled = false
		update_jobs()
		update_stats()
		update_teams()
	else:
		print("Žádný volný tým!")

func _on_buy_team() -> void:
	var gm = get_node("/root/Main/GameManager")
	if gm.buy_team():
		gm.take_action()
		next_day_button.disabled = false
		update_stats()
		update_teams()

func _on_order_cable() -> void:
	var gm = get_node("/root/Main/GameManager")
	if gm.order_cable():
		gm.take_action()
		next_day_button.disabled = false
		update_stats()

func _on_order_connectors() -> void:
	var gm = get_node("/root/Main/GameManager")
	if gm.order_connectors():
		gm.take_action()
		next_day_button.disabled = false
		update_stats()

func _on_buy_cabinet() -> void:
	var gm = get_node("/root/Main/GameManager")
	if gm.buy_cabinet():
		gm.take_action()
		next_day_button.disabled = false
		update_stats()

func update_stats() -> void:
	var gm = get_node("/root/Main/GameManager")
	money_label.text = "💰 Peníze: %d Kč" % gm.money
	reputation_label.text = "⭐ Reputace: %d %%" % gm.reputation
	day_label.text = "📅 Den: %d" % gm.day
	teams_label.text = "👷 Týmy: %d" % gm.teams_total
	material_label.text = "📦 Kabel: %dm | Konektory: %d ks | Rozvaděče: %d" % [gm.cable, gm.connectors, gm.cabinets_available]

func update_jobs() -> void:
	var gm = get_node("/root/Main/GameManager")
	for child in jobs_panel.get_children():
		if child != jobs_header:
			child.free()
	for job in gm.job_manager.active_jobs:
		var row = HBoxContainer.new()
		var label = Label.new()
		label.text = "%s | ⏳ %d dní | 💰 %d Kč | 🔴 %d Kč" % [
			job.get_label(),
			job.days_remaining,
			job.reward,
			job.penalty
		]
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var button = Button.new()
		button.text = "Přiřadit tým"
		button.pressed.connect(_on_assign_pressed.bind(job))
		row.add_child(label)
		row.add_child(button)
		jobs_panel.add_child(row)

func update_teams() -> void:
	var gm = get_node("/root/Main/GameManager")
	for child in teams_panel.get_children():
		if child != teams_header:
			child.free()
	for team in gm.teams:
		var label = Label.new()
		label.text = team.get_label()
		teams_panel.add_child(label)
