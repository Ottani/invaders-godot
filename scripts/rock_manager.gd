extends Node2D

const ROCK = preload("uid://j76d83ibbc6j")
const NUM_ROCKS: int = 5
const ROCK_GAP: float = 64.0
const ROCK_SIZE: float = 48.0
const ROCKS_Y: float = 240.0 + ROCK_SIZE / 2.0
var screen_size: Vector2


func _ready() -> void:
	screen_size = get_viewport_rect().size
	var start_pos: Vector2 = Vector2(
			(screen_size.x - (NUM_ROCKS * ROCK_SIZE) - (NUM_ROCKS - 1.0) * ROCK_GAP)
				/ 2.0,
			ROCKS_Y,
		)
	for i in NUM_ROCKS:
		var rock: Rock = ROCK.instantiate() as Rock
		rock.global_position =Vector2(
			start_pos.x + i * (ROCK_SIZE + ROCK_GAP), start_pos.y
		)
		add_child(rock)
