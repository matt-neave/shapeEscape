extends CanvasLayer
@onready var exit = $CenterContainer/VBoxContainer/Exit


# Called when the node enters the scene tree for the first time.
func _ready():
	exit.pressed.connect(_exit)

func _exit():
	SoundManager.play_sound(SoundManager.SOUNDS.BUTTON_CLICK)
	GameManager._on_level_complete()  # Call the level complete function
