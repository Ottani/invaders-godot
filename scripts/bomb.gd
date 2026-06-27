class_name Bomb extends Area2D

const MIN_SPEED: float = 50.0;
const MAX_SPEED: float = 100.0;
const DIRECTION: Vector2 = Vector2(0, 1)

var speed: float
var screen_size: Vector2


func _ready() -> void:
	speed = randf_range(MIN_SPEED, MAX_SPEED)
	screen_size = get_viewport_rect().size


func _physics_process(delta: float) -> void:
	position += DIRECTION * speed * delta
	if position.y > screen_size.y:
		queue_free()
	
