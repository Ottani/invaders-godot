class_name Game extends Node


const PLAYER = preload("uid://008kmsqhoftq")
const EXPLOSION = preload("uid://bs4w2if84ps2x")

@export var ship_anchor: Node2D
@export var bullet_manager: BulletManager
@export var enemy_manager: EnemyManager
@export var ui: UI

#signal change_scene

var played_died: bool = false
var player_lives: int = 3
var score: int = 0


func _ready() -> void:
	_spawn_player(false)
	player_lives = 3
	ui.set_lives(player_lives)
	score = 0
	ui.set_score(score)
	enemy_manager.enemy_killed.connect(_on_enemy_killed)


func _spawn_player(is_invincible: bool) -> void:
	var player: Player = PLAYER.instantiate() as Player
	player.ship_died.connect(_on_player_died)
	player.bulletManager = bullet_manager
	ship_anchor.add_child(player)
	if is_invincible:
		player.make_invincible()
	enemy_manager.unfreeze_enemies()
	played_died = false


#func _input(event: InputEvent) -> void:
	#var mouse_event := event as InputEventMouseButton
	#if mouse_event and mouse_event.pressed and sprite:
		#if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			#var local_mouse_pos: Vector2 = sprite.to_local(mouse_event.position)
			#if sprite.get_rect().has_point(local_mouse_pos):
				#change_scene.emit(Main.Scene.MAIN)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if played_died and event.is_action_pressed("ui_accept"):
		ui.toggle_message(false)
		_spawn_player(true)


func _on_player_died(position: Vector2) -> void:
	enemy_manager.freeze_enemies()
	var explosion: AnimatedSprite2D = EXPLOSION.instantiate() as AnimatedSprite2D
	explosion.global_position = position
	add_child(explosion)
	explosion.animation_finished.connect(func() -> void:
		explosion.queue_free()
	)
	player_lives -= 1
	ui.set_lives(player_lives)
	if player_lives > 0:
		await get_tree().create_timer(1.0).timeout
		ui.toggle_message(true)
		played_died = true


func _on_enemy_killed(points: int) -> void:
	score += points
	ui.set_score(score)
