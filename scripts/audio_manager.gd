extends Node

@export var laser_audio_player: AudioStreamPlayer
@export var explosion_audio_player: AudioStreamPlayer
@export var ship_explosion_audio_player: AudioStreamPlayer
@export var bomb_audio_player: AudioStreamPlayer
@export var music_player: AudioStreamPlayer


func play_laser() -> void:
	laser_audio_player.pitch_scale = randf_range(1.0, 1.4)
	laser_audio_player.play()


func play_laser_explosion() -> void:
	explosion_audio_player.pitch_scale = randf_range(0.9, 1.1)
	explosion_audio_player.play()


func play_ship_explosion() -> void:
	ship_explosion_audio_player.pitch_scale = randf_range(0.9, 1.1)
	ship_explosion_audio_player.play()


func play_bomb_explosion() -> void:
	bomb_audio_player.pitch_scale = randf_range(0.9, 1.1)
	bomb_audio_player.play()


func play_music() -> void:
	music_player.play()
	

func stop_music() -> void:
	music_player.stop()
	
	
func pause_music(value: bool) -> void:
	music_player.stream_paused = value
