class_name Rock extends Area2D

@export var sprite: Sprite2D
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
	image = Image.create(region.size.x , region.size.y, false, full_image.get_format())
	image.blit_rect(full_image, region, Vector2i.ZERO)
	sprite_offset = Vector2(image.get_width() / 2.0, image.get_height() / 2.0)
	image_size = Vector2(image.get_width(), image.get_height())
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


func _process_projectile_hit(area: Area2D) -> void:
	if area is Enemy:
		queue_free()
	elif area is Bomb or area is Bullet:
		var size: Vector2
		var is_bomb: bool = area is Bomb
		if is_bomb:
			size = Vector2(2.0, 2.0)
		else:
			size = Vector2(6.0, 4.0)
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
			_carve_hole(local_pos, 8.0)
			area.queue_free()


func _carve_hole(origin: Vector2, radius: float) -> void:
	var start_x: int = clampi(int(origin.x - radius), 0, image_size.x)
	var end_x: int = clampi(int(origin.x + radius), 0, image_size.x)
	var start_y: int = clampi(int(origin.y - radius), 0, image_size.y)
	var end_y: int = clampi(int(origin.y + radius), 0, image_size.y)
	var radius_sq: float = radius * radius
	for y in range(start_y, end_y):
			for x in range(start_x, end_x):
				if origin.distance_squared_to(Vector2(x, y)) <= radius_sq:
					image.set_pixel(x, y, Color.TRANSPARENT)
	dirty = true
