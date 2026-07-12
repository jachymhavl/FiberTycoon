extends Node2D

var tile_size: int = 56
var grid_width: int = 20
var grid_height: int = 17
var houses: Array = []
var cabinets: Array = []
var default_cabinet_pos: Vector2 = Vector2(4, 6)
var cabinet_range: int = 4

var tex_house = preload("res://assets/kenney_tiny-battle/Tiles/tile_0008.png")
var tex_grass = preload("res://assets/kenney_tiny-battle/Tiles/tile_0001.png")
var tex_road = preload("res://assets/Tiles/tile_0043.png")
var tex_cabinet = preload("res://assets/kenney_tiny-battle/Tiles/tile_0053.png")

func _ready() -> void:
	_draw_ground()
	_draw_roads()
	_place_cabinet(default_cabinet_pos)
	_place_houses()
	print("Mapa načtena, domů: ", houses.size())

func _draw_ground() -> void:
	for x in range(grid_width):
		for y in range(grid_height):
			var tile = Sprite2D.new()
			tile.texture = tex_grass
			tile.position = Vector2(x * tile_size + tile_size / 2, y * tile_size + tile_size / 2)
			tile.scale = Vector2(float(tile_size) / tex_grass.get_width(), float(tile_size) / tex_grass.get_height())
			add_child(tile)

func _draw_roads() -> void:
	for row in [2, 4, 6, 8, 10, 12, 14]:
		for x in range(grid_width):
			var tile = Sprite2D.new()
			tile.texture = tex_road
			tile.position = Vector2(x * tile_size + tile_size / 2, row * tile_size + tile_size / 2)
			tile.scale = Vector2(float(tile_size) / tex_road.get_width(), float(tile_size) / tex_road.get_height())
			add_child(tile)
	for col in [3, 6, 9, 12, 15, 18]:
		for y in range(grid_height):
			var tile = Sprite2D.new()
			tile.texture = tex_road
			tile.position = Vector2(col * tile_size + tile_size / 2, y * tile_size + tile_size / 2)
			tile.scale = Vector2(float(tile_size) / tex_road.get_width(), float(tile_size) / tex_road.get_height())
			add_child(tile)

func _place_cabinet(pos: Vector2) -> void:
	var cab = Sprite2D.new()
	cab.texture = tex_cabinet
	cab.position = Vector2(pos.x * tile_size + tile_size / 2, pos.y * tile_size + tile_size / 2)
	cab.scale = Vector2(float(tile_size - 4) / tex_cabinet.get_width(), float(tile_size - 4) / tex_cabinet.get_height())
	add_child(cab)
	var label = Label.new()
	label.text = "⚡"
	label.position = Vector2(pos.x * tile_size + 12, pos.y * tile_size + 8)
	add_child(label)
	cabinets.append(pos)
	_draw_cabinet_range(pos)
	_update_house_ranges()

func _draw_cabinet_range(cab_pos: Vector2) -> void:
	for x in range(grid_width):
		for y in range(grid_height):
			var dist = abs(x - cab_pos.x) + abs(y - cab_pos.y)
			if dist <= cabinet_range and dist > 0:
				var indicator = ColorRect.new()
				indicator.size = Vector2(tile_size, tile_size)
				indicator.position = Vector2(x * tile_size, y * tile_size)
				indicator.color = Color(1.0, 1.0, 0.0, 0.06)
				indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
				add_child(indicator)

func _place_houses() -> void:
	var house_positions = [
		Vector2(1, 1), Vector2(3, 1), Vector2(5, 1), Vector2(8, 1), Vector2(11, 1), Vector2(14, 1), Vector2(17, 1),
		Vector2(2, 3), Vector2(4, 3), Vector2(7, 3), Vector2(10, 3), Vector2(13, 3), Vector2(16, 3), Vector2(19, 3),
		Vector2(1, 5), Vector2(3, 5), Vector2(6, 5), Vector2(9, 5), Vector2(12, 5), Vector2(15, 5), Vector2(18, 5),
		Vector2(2, 7), Vector2(5, 7), Vector2(8, 7), Vector2(11, 7), Vector2(14, 7), Vector2(17, 7),
		Vector2(1, 9), Vector2(4, 9), Vector2(7, 9), Vector2(10, 9), Vector2(13, 9), Vector2(16, 9), Vector2(19, 9),
		Vector2(2, 11), Vector2(5, 11), Vector2(8, 11), Vector2(11, 11), Vector2(14, 11), Vector2(17, 11),
		Vector2(1, 13), Vector2(3, 13), Vector2(6, 13), Vector2(9, 13), Vector2(12, 13), Vector2(15, 13), Vector2(18, 13),
		Vector2(2, 15), Vector2(5, 15), Vector2(8, 15), Vector2(11, 15), Vector2(14, 15), Vector2(17, 15),
	]
	for pos in house_positions:
		var in_range = _is_in_any_cabinet_range(pos)
		var house = Sprite2D.new()
		house.texture = tex_house
		house.position = Vector2(pos.x * tile_size + tile_size / 2, pos.y * tile_size + tile_size / 2)
		house.scale = Vector2(float(tile_size - 6) / tex_house.get_width(), float(tile_size - 6) / tex_house.get_height())
		if in_range:
			house.modulate = Color(1.0, 1.0, 1.0)
		else:
			house.modulate = Color(0.5, 0.5, 0.5)
		add_child(house)
		var label = Label.new()
		label.text = ""
		label.position = Vector2(pos.x * tile_size + 10, pos.y * tile_size + 8)
		add_child(label)
		houses.append({
			"node": house,
			"label": label,
			"pos": pos,
			"connected": false,
			"in_range": in_range,
			"status": "none"
		})

func _is_in_any_cabinet_range(pos: Vector2) -> bool:
	for cab_pos in cabinets:
		var dist = abs(pos.x - cab_pos.x) + abs(pos.y - cab_pos.y)
		if dist <= cabinet_range:
			return true
	return false

func _update_house_ranges() -> void:
	for house in houses:
		house["in_range"] = _is_in_any_cabinet_range(house["pos"])
		if not house["connected"] and house["in_range"]:
			house["node"].modulate = Color(1.0, 1.0, 1.0)

func try_place_cabinet(click_pos: Vector2) -> bool:
	var grid_x = int(click_pos.x / tile_size)
	var grid_y = int(click_pos.y / tile_size)
	var grid_pos = Vector2(grid_x, grid_y)
	for house in houses:
		if house["pos"] == grid_pos:
			return false
	for cab in cabinets:
		if cab == grid_pos:
			return false
	var gm = get_node("/root/Main/GameManager")
	if not gm.place_cabinet():
		return false
	gm.use_cabinet()
	_place_cabinet(grid_pos)
	return true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var click_pos = event.position
		if event.button_index == MOUSE_BUTTON_LEFT:
			for house in houses:
				var pos = house["pos"]
				var rect = Rect2(pos.x * tile_size + 3, pos.y * tile_size + 3, tile_size - 6, tile_size - 6)
				if rect.has_point(click_pos):
					_on_house_clicked(house)
					return
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if try_place_cabinet(click_pos):
				print("Rozvaděč umístěn!")

func _on_house_clicked(house: Dictionary) -> void:
	if not house["in_range"]:
		print("Dům je mimo dosah rozvaděče!")
		return
	var gm = get_node("/root/Main/GameManager")
	if house["status"] == "fault" or house["status"] == "complaint":
		if gm.cable < 20 or gm.connectors < 2:
			print("Nedostatek materiálu na opravu!")
			return
		for team in gm.teams:
			if not team.is_busy:
				team.is_busy = true
				team.days_until_free = 1
				gm.cable -= 20
				gm.connectors -= 2
				var job_type = Job.Type.FAULT if house["status"] == "fault" else Job.Type.COMPLAINT
				for job in gm.job_manager.active_jobs:
					if job.type == job_type:
						gm.job_manager.active_jobs.erase(job)
						break
				reputation_bonus(gm)
				house["status"] = "connected"
				house["node"].modulate = Color(0.2, 1.0, 0.2)
				house["label"].text = "🟢"
				gm.take_action()
				_refresh_ui()
				print("Dům opraven!")
				return
		print("Žádný volný tým!")
		return
	if house["connected"]:
		print("Dům už je připojený")
		return
	var result = gm.assign_team_to_job_from_map()
	if result:
		house["connected"] = true
		house["status"] = "connected"
		house["node"].modulate = Color(0.2, 1.0, 0.2)
		house["label"].text = "🟢"
		gm.take_action()
		_refresh_ui()
		print("Dům připojen!")
	else:
		print("Žádný volný tým nebo nedostatek materiálu!")

func reputation_bonus(gm) -> void:
	gm.reputation += 2
	if gm.reputation > 100:
		gm.reputation = 100
	print("Reputace +2 za včasnou opravu!")

func _refresh_ui() -> void:
	var root = get_tree().current_scene
	var btn = root.find_child("next_day", true, false)
	if btn:
		btn.disabled = false
	var ui_node = root.find_child("UI", true, false)
	if ui_node and ui_node.has_method("update_stats"):
		ui_node.update_stats()
		ui_node.update_teams()

func set_house_status(index: int, status: String) -> void:
	if index >= houses.size():
		return
	var house = houses[index]
	house["status"] = status
	match status:
		"fault":
			house["node"].modulate = Color(1.0, 0.2, 0.2)
			house["label"].text = "🔴"
		"complaint":
			house["node"].modulate = Color(1.0, 1.0, 0.2)
			house["label"].text = "🟡"
		"connected":
			house["node"].modulate = Color(0.2, 1.0, 0.2)
			house["label"].text = "🟢"
