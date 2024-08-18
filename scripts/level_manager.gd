extends Node2D

enum GameState {
	BUILD,
	PLAY
}

@onready var start_button: Button = $UI/StartButton
@onready var reset_button = $CanvasLayer/Button
@onready var phase_1_camera: Camera2D = $Phase1Camera
@onready var ui = $UI

const PLAYER = preload("res://scenes/player.tscn")

var game_state = GameState.BUILD

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(_toggle_game_state)
	reset_button.pressed.connect(_reset_game)
	_reset_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _toggle_game_state():
	_start_game()

func _start_game():
	game_state = GameState.PLAY
	ui.hide()
	var player = PLAYER.instantiate()
	add_child(player)
	

func _reset_game():
	game_state = GameState.BUILD
	ui.show()
	SoundManager.play_music(SoundManager.SOUNDS.BUILD_MUSIC)
	
	# Remove the player
	for child in get_children():
		if child.name == "Player":
			child.queue_free()
			
	# Set camera
	phase_1_camera.make_current()
	
	# Reset the tile control
	get_tree().call_group("tile_control", "_reset")
	get_tree().call_group("ui_control", "fetch_ui_data")

