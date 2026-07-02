class_name BombManager extends Node2D

const BOMB = preload("uid://0ui1nc183yn3")
const MAX_BOMBS: int = 15

func spawn_bomb(global_spawn_position: Vector2) -> void:
	if get_child_count() >= MAX_BOMBS:
		return
	
	var bomb: Bomb = BOMB.instantiate() as Bomb
	bomb.global_position = global_spawn_position
	add_child(bomb)


func clear_all_bombs() -> void:
	for bomb in get_children():
		bomb.queue_free()
