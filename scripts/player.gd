extends CharacterBody2D

@export var sprite: AnimatedSprite2D
@export var marker_2d: Marker2D
@export var bulletManager: BulletManager


const SPEED: float = 250.0

var min_x: float
var max_x: float


func _ready() -> void:
	var half_width: float = 16.0
	var screen_width: float = get_viewport_rect().size.x
	min_x = 0.0 + half_width
	max_x = screen_width - half_width


func _physics_process(delta: float) -> void:
	var direction := Vector2(Input.get_axis("left", "right"), 0)
	position += direction * SPEED * delta
	position.x = clampf(position.x, min_x, max_x)
	if sprite:
		if direction.x != 0.0:
			sprite.set_animation("moving")
		else:
			sprite.set_animation("idle")


func _unhandled_input(event: InputEvent) -> void:
	if bulletManager and event.is_action_pressed("shoot"):
		bulletManager.spawn_bullet(marker_2d.global_position)
