class_name DefeatScreen extends CanvasLayer

@export var button_restart: Button


func _ready() -> void:
	AudioManager.pause_music(true)
	get_tree().paused = true
	button_restart.grab_focus()


func _on_button_restart_pressed() -> void:
	SceneManager.restart_game()


func _on_button_quit_pressed() -> void:
	SceneManager.change_scene_to_menu()
