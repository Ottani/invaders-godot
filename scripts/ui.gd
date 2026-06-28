class_name UI extends CanvasLayer


@export var continue_message: RichTextLabel
@export var lives_container: HBoxContainer
@export var score_label: Label
const LIFE = preload("uid://cqxrhclqdmc7m")


func _ready() -> void:
	continue_message.visible = false


func toggle_message(value: bool) -> void:
	continue_message.visible = value


func set_lives(lives: int) -> void:
	for child in lives_container.get_children():
		lives_container.remove_child(child)
		child.queue_free()
	for i in range(lives):
		var heart_instance: TextureRect = LIFE.instantiate() as TextureRect
		lives_container.add_child(heart_instance)


func set_score(score: int) -> void:
	score_label.text = "Points: %d" % score
