class_name MainMenu extends CanvasLayer

@export var button_play: Button
@export var button_quit: Button
@export var button_fullscreen: CheckButton


func _ready() -> void:
	button_play.pressed.connect(_on_button_play_pressed)
	button_fullscreen.toggled.connect(_on_fullscreen_toggle)
	button_quit.pressed.connect(_on_button_quit_pressed)
	button_play.grab_focus()


func _on_button_play_pressed() -> void:
	get_tree().paused = false
	SceneManager.change_scene_to_game()


func _on_fullscreen_toggle(toggled_on: bool) -> void:
	var current_mode := DisplayServer.window_get_mode()
	var new_mode := DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED
	if current_mode != new_mode:
		DisplayServer.window_set_mode(new_mode)


func _on_button_quit_pressed() -> void:
	get_tree().paused = false
	AudioManager.stop_music()
	get_tree().quit()
