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
@onready var back_button = $"../../BackButton"
const FONT: Font = preload("res://assets/fonts/MotleyForcesRegular-w1rZ3.ttf")

func getFilePathsByExtension(directoryPath: String, extension: String) -> int:
	var dir = DirAccess.open(directoryPath)
	var counter = 0
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		counter += 1
		file_name = dir.get_next()
	
	return counter
			
var num_levels = getFilePathsByExtension("res://scenes/levels/", "tscn")

func _ready() -> void:
	generate_level_buttons()
	
# Function to generate level buttons
func generate_level_buttons() -> void:	
	for i in range(1, num_levels + 1):
		var button = Button.new()
		button.add_theme_font_size_override("font_size", 60)
		button.text = "Level %d" % i
		button.name = "Level%d" % i
		button.add_theme_font_override("font", FONT)
		if GameManager.level_data[i - 1]["unlocked"]:
			button.pressed.connect(_on_level_button_pressed.bind(i))
		else:
			button.disabled = true  # the level is locked
		
		add_child(button)
	
	back_button.pressed.connect(_on_Back_pressed)

		
func _on_level_button_pressed(level: int) -> void:
	var scene_path = "res://scenes/levels/level_%d.tscn" % level
	GameManager.current_level_index = (level - 1)
	get_tree().change_scene_to_file(scene_path)

func _on_Back_pressed() -> void:
	SoundManager.play_sound(SoundManager.SOUNDS.BUTTON_CLICK)	
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
