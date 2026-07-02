class_name PauseScreen extends CanvasLayer

@export var button_resume: Button


func _ready() -> void:
	button_resume.grab_focus()


func _on_button_resume_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_button_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_button_quit_pressed() -> void:
	get_tree().quit()
