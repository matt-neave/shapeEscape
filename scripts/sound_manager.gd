extends Node

enum SOUNDS {
	TILE_PLACE,
	BUILD_MUSIC,
	BUTTON_CLICK
}

const AUDIO_TRACKS = {
	SOUNDS.TILE_PLACE: preload("res://sfx/tile_place.wav"),
	SOUNDS.BUILD_MUSIC: preload("res://sfx/Equatorial Complex.mp3"),
	SOUNDS.BUTTON_CLICK: preload("res://sfx/button_click.wav"),
}

var music_player = AudioStreamPlayer2D.new()

func _ready():
	add_child(music_player)

func play_sound(sound: SOUNDS, position: Vector2 = Vector2.ZERO, volume: float = 0):
	var player = AudioStreamPlayer2D.new()
	player.stream = AUDIO_TRACKS[sound]
	player.volume_db = volume
	player.global_position = position
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func play_music(sound: SOUNDS, volume: float = 0):
	music_player.stream = AUDIO_TRACKS[sound]
	music_player.volume_db = volume
	music_player.play()
