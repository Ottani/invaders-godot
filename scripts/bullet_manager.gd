class_name BulletManager extends Node2D

@export var bullet_scene: PackedScene

const MAX_BULLETS: int = 5


func spawn_bullet(global_spawn_position: Vector2) -> void:
	if get_child_count() > MAX_BULLETS:
		return
	
	var bullet: Bullet = bullet_scene.instantiate() as Bullet
	bullet.global_position = global_spawn_position
	add_child(bullet)
