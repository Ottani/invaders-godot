extends Node

#signal change_scene


#func _input(event: InputEvent) -> void:
	#var mouse_event := event as InputEventMouseButton
	#if mouse_event and mouse_event.pressed and sprite:
		#if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			#var local_mouse_pos: Vector2 = sprite.to_local(mouse_event.position)
			#if sprite.get_rect().has_point(local_mouse_pos):
				#change_scene.emit(Main.Scene.MAIN)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
