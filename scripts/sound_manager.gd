extends Node

enum SOUNDS {
	TILE_PLACE,
	BUILD_MUSIC,
	BUTTON_CLICK,
	FOOT_STEP,
	LEVEL_COMPLETE,
}

const AUDIO_TRACKS = {
	SOUNDS.TILE_PLACE: preload("res://sfx/tile_place.wav"),
	SOUNDS.BUILD_MUSIC: preload("res://sfx/Equatorial Complex.mp3"),
	SOUNDS.BUTTON_CLICK: preload("res://sfx/button_click.wav"),
	SOUNDS.FOOT_STEP: preload("res://sfx/foot_step.wav"),
	SOUNDS.LEVEL_COMPLETE: preload("res://sfx/level_complete.wav"),
}

var music_player = AudioStreamPlayer2D.new()

func _ready():
	add_child(music_player)

func play_sound(sound: SOUNDS, position: Vector2 = Vector2.ZERO, volume: float = 0, unique: bool = false):
	if unique:
		var sounds = get_children()
		for playing_sound in sounds:
			if playing_sound.name == str(sound):
				return
	
	var player = AudioStreamPlayer2D.new()
	player.stream = AUDIO_TRACKS[sound]
	player.volume_db = volume
	player.global_position = position
	player.name = str(sound)
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
	
func kill_sound(sound: SOUNDS, all: bool = true):
	var sounds = get_children()
	for playing_sound in sounds:
		if playing_sound.name.contains(str(sound)):
			playing_sound.queue_free()
			if !all:
				return

func play_music(sound: SOUNDS, volume: float = 0):
	music_player.stream = AUDIO_TRACKS[sound]
	music_player.volume_db = volume
	music_player.play()
