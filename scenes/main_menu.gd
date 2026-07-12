extends Control

@onready var title = $title
@onready var play_button = $play_button

func _ready() -> void:
	var bg = ColorRect.new()
	bg.color = Color(0.08, 0.08, 0.1, 1.0)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	move_child(bg, 0)
	title.text = "⚡ FiberTycoon ⚡"
	title.add_theme_font_size_override("font_size", 56)
	title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.0))
	title.position = Vector2(620, 250)
	var subtitle = Label.new()
	subtitle.text = "Postav optickou síť. Řiď firmu. Přežij."
	subtitle.add_theme_font_size_override("font_size", 20)
	subtitle.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	subtitle.position = Vector2(640, 340)
	add_child(subtitle)
	play_button.text = "▶ Hrát"
	play_button.position = Vector2(750, 420)
	play_button.size = Vector2(200, 50)
	play_button.pressed.connect(_on_play_pressed)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
