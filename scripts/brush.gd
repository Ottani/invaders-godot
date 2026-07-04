class_name Brush extends Resource

@export var texture: Texture2D:
	set(val):
		if texture != val:
			texture = val
			_is_runtime_ready = false

var _image: Image
var _blank_image: Image
var _src_rect: Rect2i
var _half_size: Vector2
var _is_runtime_ready: bool = false

var half_size: Vector2:
	get:
		if _is_runtime_ready:
			return _half_size
		elif texture:
			var temp_img := texture.get_image()
			return Vector2(temp_img.get_size()) / 2.0
		return Vector2.ZERO


func _initialize_brush(target_format: Image.Format) -> void:
	if _is_runtime_ready and _image.get_format() == target_format:
		return
	_image = texture.get_image()
	if _image.is_compressed():
		_image.decompress()
	_image.convert(target_format)
	_blank_image = Image.create_empty(
		_image.get_width(),
		_image.get_height(), 
		false, 
		_image.get_format())
	var size: Vector2i = _image.get_size()
	_src_rect = Rect2i(Vector2i.ZERO, size)
	_half_size = Vector2(size) / 2.0
	_is_runtime_ready = true


func apply(dest: Image, pos: Vector2i) -> void:
	if not dest or not texture:
		return
	_initialize_brush(dest.get_format())
	dest.blit_rect_mask(
		_blank_image,
		_image,
		_src_rect,
		pos
	)
