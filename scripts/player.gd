class_name Player extends CharacterBody2D

@export var ship: AnimatedSprite2D
@export var marker_2d: Marker2D
@export var bulletManager: BulletManager
@export var animation_player: AnimationPlayer

signal ship_died(position: Vector2)

const SPEED: float = 250.0

var min_x: float
var max_x: float
var is_alive: bool = true
var is_invincible: bool = false


func _ready() -> void:
	var half_width: float = 16.0
	var screen_width: float = get_viewport_rect().size.x
	min_x = 0.0 + half_width
	max_x = screen_width - half_width
	is_alive = true


func _physics_process(delta: float) -> void:
	if not is_alive:
		return
	var direction := Vector2(Input.get_axis("left", "right"), 0)
	global_position += direction * SPEED * delta
	global_position.x = clampf(global_position.x, min_x, max_x)
	if ship:
		if direction.x != 0.0:
			ship.set_animation("moving")
		else:
			ship.set_animation("idle")


func _unhandled_input(event: InputEvent) -> void:
	if not is_alive:
		return
	if bulletManager and event.is_action_pressed("shoot"):
		bulletManager.spawn_bullet(marker_2d.global_position)


func take_damage(_value: int) -> void:
	if not is_alive or is_invincible:
		return
	is_alive = false
	ship_died.emit(global_position)
	queue_free()


func make_invincible() -> void:
	is_invincible = true
	animation_player.play("spawn_invincible")
	await animation_player.animation_finished
	is_invincible = false
