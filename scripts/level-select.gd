#extends VBoxContainer
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


extends VBoxContainer

# Function to be called when the node enters the scene tree
func _ready() -> void:
	# Connect button signals to the corresponding functions
	$Level1.pressed.connect(_on_Level1_pressed)
	#$Level2.pressed.connect(_on_Level2_pressed)
	#$Level3.pressed.connect(_on_Level3_pressed)
	$Back.pressed.connect(_on_Back_pressed)

# Function for when Level1 button is pressed
func _on_Level1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/sample_world.tscn")

## Function for when Level2 button is pressed
#func _on_Level2_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/Level2.tscn")
#
## Function for when Level3 button is pressed
#func _on_Level3_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/Level3.tscn")

# Function for when Back button is pressed
func _on_Back_pressed() -> void:
	SoundManager.play_sound(SoundManager.SOUNDS.BUTTON_CLICK)	
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")  # Replace with your actual menu scene path
