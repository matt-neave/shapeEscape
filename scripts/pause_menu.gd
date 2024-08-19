extends CanvasLayer

@onready var resume = $CenterContainer/VBoxContainer/Resume
@onready var back_to_level_map = $CenterContainer/VBoxContainer/BackToLevelMap

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("pause")
	resume.pressed.connect(pause)
	back_to_level_map.pressed.connect(_back_to_level_map)
	
func pause():
	get_tree().paused = !get_tree().paused
	visible = !visible

func _back_to_level_map():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause()
