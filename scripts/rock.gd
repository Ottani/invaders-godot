class_name Rock extends Area2D


func _ready() -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area is Bomb or area is Bullet:
		area.queue_free()
	elif area is Enemy:
		queue_free()
