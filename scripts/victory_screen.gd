class_name VictoryScreen extends CanvasLayer

@export var button_restart: Button


func _ready() -> void:
	get_tree().paused = true
	button_restart.grab_focus()


func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
