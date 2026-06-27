class_name MainMenu extends CanvasLayer

signal change_scene


func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_play_pressed() -> void:
	change_scene.emit(Main.Scene.GAME)
