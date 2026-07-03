class_name PauseScreen extends CanvasLayer

@export var button_resume: Button


func _ready() -> void:
	AudioManager.pause_music(true)
	button_resume.grab_focus()


func _on_button_resume_pressed() -> void:
	get_tree().paused = false
	AudioManager.pause_music(false)
	queue_free()


func _on_button_restart_pressed() -> void:
	SceneManager.restart_game()


func _on_button_quit_pressed() -> void:
	SceneManager.change_scene_to_menu()
