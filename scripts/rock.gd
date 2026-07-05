class_name Rock extends Area2D

@export var sprite: Sprite2D
@export var enemy_brush: Brush
@export var bomb_brush: Brush
@export var explosion_particles: PackedScene

var image: Image
var sprite_offset: Vector2
var image_size: Vector2i
var dirty: bool = false
var rock_texture: ImageTexture


func _ready() -> void:
	var texture: Texture2D = sprite.texture
	var region: Rect2i = sprite.region_rect
	var full_image: Image = texture.get_image()
	if full_image.is_compressed():
		full_image.decompress()
	image = Image.create_empty(region.size.x , region.size.y, false, full_image.get_format())
	image.blit_rect(full_image, region, Vector2i.ZERO)
	sprite_offset = Vector2(image.get_width() / 2.0, image.get_height() / 2.0)
	image_size = image.get_size()
	rock_texture = ImageTexture.create_from_image(image)
	sprite.region_enabled = false
	sprite.texture = rock_texture
	dirty = false


func _physics_process(_delta: float) -> void:
	var objs: Array[Area2D] = get_overlapping_areas()
	if objs.is_empty():
		return
	for obj: Area2D in objs:
		_process_projectile_hit(obj)
	if dirty:
		rock_texture.update(image)
		dirty = false
		var used_rect: Rect2i = image.get_used_rect()
		if used_rect.size.x < 8 or used_rect.size.y < 8:
			queue_free()


func _process_projectile_hit(area: Area2D) -> void:
	if area is Enemy:
		_process_enemy_hit(area as Enemy)
		return
	
	if area is Bomb or area is Bullet:
		var size: Vector2
		var is_bomb: bool = area is Bomb
		if is_bomb:
			size = Vector2(2.0, 2.0)
		elif area is Bullet:
			size = Vector2(6.0, 4.0)
		else:
			size = Vector2(32.0, 32.0)
		var local_pos: Vector2 = to_local(area.global_position) + sprite_offset
		var start_x: int = clampi(int(local_pos.x - size.x), 0, image_size.x)
		var end_x: int = clampi(int(local_pos.x + size.x), 0, image_size.x)
		var start_y: int = clampi(int(local_pos.y - size.y), 0, image_size.y)
		var end_y: int = clampi(int(local_pos.y + size.y), 0, image_size.y)
		var actual_hit: bool = false
		var bomb_radius_sq: float = size.x * size.x
		for y in range(start_y, end_y):
			for x in range(start_x, end_x):
				if not is_bomb or local_pos.distance_squared_to(Vector2(x, y)) <= bomb_radius_sq:
					if image.get_pixel(x, y).a > 0.1:
						actual_hit = true
						break
			if actual_hit:
				break

		if actual_hit:
			AudioManager.bomb_audio_player.play();
			var vfx: GPUParticles2D = explosion_particles.instantiate() as GPUParticles2D
			add_child(vfx)
			vfx.global_position = area.global_position
			_carve_hole(local_pos)
			area.queue_free()


func _carve_hole(origin: Vector2) -> void:
	var paste_target := Vector2i(origin - bomb_brush.half_size)
	bomb_brush.apply(image, paste_target)
	dirty = true


func _process_enemy_hit(enemy: Enemy) -> void:
	var local_pos: Vector2 = to_local(enemy.global_position)
	var paste_target := Vector2i(local_pos + sprite_offset - enemy_brush.half_size)
	enemy_brush.apply(image, paste_target)
	dirty = true
