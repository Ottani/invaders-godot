class_name EnemyManager extends Node2D

const ENEMY = preload("uid://bnisi3kxdkoau")
@export var bomb_manager: BombManager

const COLS: int = 10
const ROWS: int = 5
const GAP: float = 8.00
const SPEED: float = 50.0
const HALF_WIDTH: float = 32.0 / 2.0
const ENEMY_DOWNWARDS: float = 16.0
const ENEMY_SHOOT_DELAY: float = 0.75
const MIN_SHOOTERS: int = 2
const MAX_SHOOTERS: int = 6

var direction: float = 1.0
var screen_size: Vector2
var enemy_shoot_delay: float = 0.0

var active_enemies: Array[Enemy] = []

signal enemy_killed(points: int)
signal all_enemies_killed
signal enemy_invaded


func _ready() -> void:
	screen_size = get_viewport_rect().size
	for y in ROWS:
		var enemy_type: Enemy.EnemyType
		match y:
			0: enemy_type = Enemy.EnemyType.DieHard
			1: enemy_type = Enemy.EnemyType.Strong
			2: enemy_type = Enemy.EnemyType.Normal
			_: enemy_type = Enemy.EnemyType.Weak
		for x in COLS:
			var enemy_position: Vector2 = Vector2(x * (32.0 + GAP) + 16.0, y * 32.0 + 40.0)
			var enemy: Enemy = ENEMY.instantiate() as Enemy
			enemy.enemy_type = enemy_type
			enemy.position = enemy_position
			enemy.destroyed.connect(_on_enemy_destroyed.bind(enemy))
			add_child(enemy)
			active_enemies.append(enemy)


func _physics_process(delta: float) -> void:
	if active_enemies.is_empty():
		return
	
	var move_step: Vector2 = Vector2(direction * SPEED * delta, 0)
	var switch_direction := false
	for enemy in active_enemies:
		var next_x: float = enemy.global_position.x + move_step.x
		if direction > 0 and (next_x + HALF_WIDTH) >= screen_size.x:
			switch_direction = true
			break
		elif direction < 0 and (next_x - HALF_WIDTH) <= 0:
			switch_direction = true
			break

	var movement: Vector2 = move_step
	if switch_direction:
		direction *= -1
		movement = Vector2(0, ENEMY_DOWNWARDS)
	
	for enemy in active_enemies:
		enemy.global_position += movement
		if enemy.global_position.y > screen_size.y - 24.0:
			enemy_invaded.emit()
			break
	
	enemy_shoot_delay += delta
	if enemy_shoot_delay > ENEMY_SHOOT_DELAY:
		enemy_shoot_delay = 0.0
		_shoot()


func _shoot() -> void:
	if not bomb_manager or active_enemies.is_empty():
		return
	var size: int = active_enemies.size()
	var min_shooters: int = mini(size, MIN_SHOOTERS)
	var max_shooters: int = mini(size, MAX_SHOOTERS)
	var qty_shooters: int = randi_range(min_shooters, max_shooters)
	
	var chosen_indices: Array[int] = []
	while chosen_indices.size() < qty_shooters:
		var rand_idx := randi() % size
		if not rand_idx in chosen_indices:
			chosen_indices.append(rand_idx)

	for idx in chosen_indices:
		var shooter: Enemy = active_enemies[idx]
		bomb_manager.spawn_bomb(shooter.get_bomb_position())
	

func _on_enemy_destroyed(points: int, enemy_instance: Enemy) -> void:
	active_enemies.erase(enemy_instance)
	enemy_killed.emit(points)
	if active_enemies.is_empty():
		all_enemies_killed.emit()


func freeze_enemies() -> void:
	set_physics_process(false)


func unfreeze_enemies() -> void:
	set_physics_process(true)
