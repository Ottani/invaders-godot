extends Node

@export var laser_audio_player: AudioStreamPlayer
@export var explosion_audio_player: AudioStreamPlayer


func play_laser() -> void:
	laser_audio_player.pitch_scale = randf_range(1.0, 1.4)
	laser_audio_player.play()


func play_laser_explosion() -> void:
	explosion_audio_player.pitch_scale = randf_range(0.9, 1.1)
	explosion_audio_player.play()
