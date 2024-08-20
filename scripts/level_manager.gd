extends Node2D

enum GameState {
	BUILD,
	PLAY
}

const RETRY_PARTICLES = preload("res://particles/retry_particles.tscn")
@onready var level_time = $HUD/LevelTime
@onready var total_time = $HUD/TotalTime
@onready var start_button: Button = $UI/StartButton
@onready var reset_button = $HUD/Retry
@onready var phase_1_camera: Camera2D = $Phase1Camera
@onready var ui = $UI
@onready var indicators = $Indicators
@onready var undo_button = $HUD/Undo

const PLAYER = preload("res://scenes/player.tscn")

var game_state = GameState.BUILD

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(_toggle_game_state)
	reset_button.pressed.connect(_reset_game)
	_reset_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level_time:
		level_time.text = str(GameManager.level_time).pad_decimals(2)
	if total_time:
		total_time.text = str(GameManager.total_time).pad_decimals(2)

func _start_game():
	game_state = GameState.PLAY
	indicators.hide()
	undo_button.hide()
	ui.hide()
	var player = PLAYER.instantiate()
	add_child(player)
	
	if name == "Level1":
		$TextTutorial.hide()
		$TextTutorial2.hide()
		$TextTutorial3.show()
	
func _toggle_game_state():
	SoundManager.play_sound(SoundManager.SOUNDS.BUTTON_CLICK)
	_start_game()

func _reset_game():	
	SoundManager.play_sound(SoundManager.SOUNDS.BUTTON_CLICK)
	
	# Remove the player	
	var player = get_node_or_null("Player")
	if player:
		player.hide()
		var retry_particles = RETRY_PARTICLES.instantiate()
		retry_particles.global_position = player.global_position
		add_child(retry_particles)
		retry_particles.emitting = true
		await get_tree().create_timer(retry_particles.lifetime).timeout
		retry_particles.queue_free()
		player.queue_free()
		
	game_state = GameState.BUILD
	indicators.show()
	ui.show()
	undo_button.show()
	
	# Set camera
	phase_1_camera.make_current()
	
	# Reset the tile control
	get_tree().call_group("tile_control", "_reset")
	get_tree().call_group("ui_control", "fetch_ui_data")
	
	if name == "Level1":
		$TextTutorial.show()
		$TextTutorial2.show()
		$TextTutorial3.hide()
