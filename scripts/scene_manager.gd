extends Node

const MAIN_MENU: String = "uid://dardoh3gque3p"
const GAME: String = "uid://c2ymriv0wvfqi"


func change_scene_to_menu() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)


func change_scene_to_game() -> void:
	get_tree().change_scene_to_file(GAME)


func restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
