class_name Main extends Node

enum Scene {MAIN, GAME, OPTIONS}

const MAIN_MENU = preload("uid://dardoh3gque3p")
const GAME = preload("uid://c2ymriv0wvfqi")

var current_scene: Node


func _ready() -> void:
	_on_change_scene(Scene.MAIN)


func _on_change_scene(new_scene: Scene):
	if current_scene:
		if current_scene.has_signal("change_scene") and current_scene.change_scene.is_connected(_on_change_scene):
			current_scene.change_scene.disconnect(_on_change_scene)
		current_scene.queue_free()
		current_scene = null
	
	match new_scene:
		Scene.MAIN:
			current_scene = MAIN_MENU.instantiate()
		Scene.GAME:
			current_scene = GAME.instantiate()
		_:
			current_scene = null

	if current_scene:
		add_child(current_scene)
		if current_scene.has_signal("change_scene"):
			if not current_scene.change_scene.is_connected(_on_change_scene):
				current_scene.change_scene.connect(_on_change_scene)
		else:
			push_warning("Scene has no change_scene signal")
