class_name Enemy extends Area2D

enum EnemyType {
	Weak,
	Normal,
	Strong,
	DieHard,
}

@export var enemy_type: EnemyType = EnemyType.Weak
@export var sprite: AnimatedSprite2D
@export var marker: Marker2D

signal destroyed(points: int, enemy_instance: Enemy)

var life: int
var color: Color
var points: int
var hit_tween: Tween


func _ready() -> void:
	match enemy_type:
		EnemyType.Weak:
			life = 1
			color = Color.GREEN
		EnemyType.Normal:
			life = 2
			color = Color.YELLOW
		EnemyType.Strong:
			life = 4
			color = Color.ORANGE
		EnemyType.DieHard:
			life = 6
			color = Color.RED
	sprite.modulate = color
	points = life * 10


func take_damage(value: int) -> void:
	life -= value
	if life <= 0:
		destroyed.emit(points)
		queue_free()
		return
	
	if hit_tween and hit_tween.is_valid():
		hit_tween.kill()
		
	hit_tween = create_tween()
	sprite.modulate.a = 0.3
	hit_tween.tween_property(sprite, "modulate:a", 1.0, 0.2)


func get_bomb_position() -> Vector2:
	return marker.global_position


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).take_damage(1)
