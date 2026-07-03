class_name MainMenu extends CanvasLayer

@export var button_play: Button
@export var button_quit: Button


func _ready() -> void:
	button_play.pressed.connect(_on_button_play_pressed)
	button_quit.pressed.connect(_on_button_quit_pressed)
	button_play.grab_focus()


func _on_button_play_pressed() -> void:
	SceneManager.change_scene_to_game()


func _on_button_quit_pressed() -> void:
	get_tree().quit()
