class_name Bullet extends Area2D

const INITIAL_SPEED: float = 100.0
const ACCEL: float = 75.0

@export var audio_player: AudioStreamPlayer
var speed: float = 0.0


func _ready() -> void:
	speed = INITIAL_SPEED


func _physics_process(delta: float) -> void:
	speed += ACCEL * delta
	position.y -= speed * delta
	if position.y < -10.0:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		(area as Enemy).take_damage(global_position, 1)
		AudioManager.play_laser_explosion()
		queue_free()
