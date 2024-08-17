extends Node

enum SOUNDS {
	TILE_PLACE
}

const AUDIO_TRACKS = {
	SOUNDS.TILE_PLACE: preload("res://sfx/tile_place.wav")
}

func play_sound(sound: SOUNDS, position: Vector2 = Vector2.ZERO, volume: float = 0):
	var player = AudioStreamPlayer2D.new()
	player.stream = AUDIO_TRACKS[sound]
	player.volume_db = volume
	player.global_position = position
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
