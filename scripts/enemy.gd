class_name Enemy extends Area2D

enum EnemyType {
	Weak,
	Normal,
	Strong,
	DieHard,
}

@export var enemy_type: EnemyType = EnemyType.Weak
@export var sprite: AnimatedSprite2D


var life: int
var color: Color
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


func take_damage(value: int):
	life -= value
	if life <= 0:
		queue_free()
		return
	
	if hit_tween and hit_tween.is_valid():
		hit_tween.kill()
		
	hit_tween = create_tween()
	sprite.modulate.a = 0.3
	hit_tween.tween_property(sprite, "modulate:a", 1.0, 0.2)
