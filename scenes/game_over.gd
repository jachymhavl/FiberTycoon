extends Control

@onready var title = $title
@onready var restart_button = $restart_button

func _ready() -> void:
	var bg = ColorRect.new()
	bg.color = Color(0.1, 0.1, 0.12, 1.0)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	move_child(bg, 0)
	title.text = "GAME OVER"
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3))
	title.position = Vector2(700, 300)
	restart_button.text = "Hrát znovu"
	restart_button.position = Vector2(750, 420)
	restart_button.size = Vector2(200, 50)
	restart_button.pressed.connect(_on_restart_pressed)

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
