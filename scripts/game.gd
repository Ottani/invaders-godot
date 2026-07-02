class_name Game extends Node


const PLAYER = preload("uid://008kmsqhoftq")
const EXPLOSION = preload("uid://bs4w2if84ps2x")
const VICTORY_SCREEN = preload("uid://btdffvpcv8u3l")
const DEFEAT_SCREEN = preload("uid://cwgfegkjdyvcy")
const PAUSE_SCREEN = preload("uid://bmk823btowp5e")

@export var ship_anchor: Node2D
@export var bullet_manager: BulletManager
@export var enemy_manager: EnemyManager
@export var bomb_manager: BombManager
@export var ui: UI

#signal change_scene

var played_died: bool = false
var player_lives: int = 3
var score: int = 0
var handled_enemy_invasion: bool = false

func _ready() -> void:
	_spawn_player(false)
	player_lives = 3
	ui.initialize_lives(player_lives)
	ui.set_lives(player_lives)
	score = 0
	ui.set_score(score)
	enemy_manager.enemy_killed.connect(_on_enemy_killed)
	enemy_manager.all_enemies_killed.connect(_on_all_enemies_killed)
	enemy_manager.enemy_invaded.connect(_on_enemy_invaded)
	handled_enemy_invasion = false


func _spawn_player(is_invincible: bool) -> void:
	var player: Player = PLAYER.instantiate() as Player
	player.ship_died.connect(_on_player_died)
	player.bullet_manager = bullet_manager
	ship_anchor.add_child(player)
	if is_invincible:
		player.make_invincible()
	enemy_manager.unfreeze_enemies()
	played_died = false


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if has_node("PauseScreen"):
			return
		var pause_screen: PauseScreen = PAUSE_SCREEN.instantiate() as PauseScreen
		pause_screen.name = "PauseScreen"
		add_child(pause_screen)
		get_tree().paused = true
		get_tree().root.set_input_as_handled()
	if played_died and event.is_action_pressed("ui_accept"):
		ui.toggle_message(false)
		_spawn_player(true)
		get_tree().root.set_input_as_handled()


func _on_player_died(position: Vector2) -> void:
	enemy_manager.freeze_enemies()
	bomb_manager.clear_all_bombs()
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
	else:
		var defeat_screen: DefeatScreen = DEFEAT_SCREEN.instantiate() as DefeatScreen
		add_child(defeat_screen)


func _on_enemy_killed(points: int) -> void:
	score += points
	ui.set_score(score)


func _on_all_enemies_killed() -> void:
	var victory_screen: VictoryScreen = VICTORY_SCREEN.instantiate() as VictoryScreen
	add_child(victory_screen)


func _on_enemy_invaded() -> void:
	if handled_enemy_invasion:
		return
	handled_enemy_invasion = true
	var defeat_screen: DefeatScreen = DEFEAT_SCREEN.instantiate() as DefeatScreen
	add_child(defeat_screen)
