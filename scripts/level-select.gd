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

var num_levels = 1

func _ready() -> void:
	generate_level_buttons()
	#$Back.pressed.connect(_on_Back_pressed)
	
# Function to generate level buttons
func generate_level_buttons() -> void:	
	for i in range(1, num_levels + 1):
		var button = Button.new()
		button.text = "Level %d" % i
		button.name = "Level%d" % i	
		
		button.pressed.connect(_on_level_button_pressed)
		add_child(button)
		
func _on_level_button_pressed() -> void:
	var scene_path = "res://Scenes/level-%d.tscn" % 1
	print("loading", scene_path)
	get_tree().change_scene_to_file(scene_path)

func _on_Back_pressed() -> void:
	SoundManager.play_sound(SoundManager.SOUNDS.BUTTON_CLICK)	
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
