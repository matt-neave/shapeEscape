extends Node

enum GameState {
	MENU,
	LEVEL_SELECT,
	GAMEPLAY
}

var level_shapes = [
	{
		"shapes": []
	}
]

var level_data = [
	{
		"shapes" = [
			[["none", 0, 0], ["none", 1, 0]],
		],
		"multipliers" = []
	},
	{
		"shapes" = [
			[["right", 0, 0]],
		],
		"multipliers" = [4]
	},
	{
		"shapes" = [
			[["none", 0, 0], ["up", 1, 0]],
		],
		"multipliers" = [3]
	},
	{
		"shapes" = [
			[["none", 0, 0], ["left", 0, 1], ["none", 1, 0]],
			[["right", 0, 0]],
		],
		"multipliers" = [2, 2]
	},
	{
		"shapes" = [
			[["left", 0, 0]],
			[["right", 0, 0]],
			[["right", 0, 0], ["left", 2, -1]],
		],
		"multipliers" = [2, 2, 3, 2, 2, 2]
	},
	#{
		#"shapes" = [],
		#"multipliers" = []
	#},    
	#{
		#"shapes" = [],
		#"multipliers" = []
	#}
]

var level = 0
var levels = ["res://scenes/sample_world.tscn"]
var current_level_index = 0

var current_state: GameState = GameState.MENU

var level_unlocked = [true, false]

func _ready():
	_test_shapes()
	_go_to_menu()
	SoundManager.play_music(SoundManager.SOUNDS.BUILD_MUSIC)

func _go_to_menu():
	current_state = GameState.MENU
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _go_to_level_select():
	current_state = GameState.LEVEL_SELECT
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

#func _start_level(level_path: String):
	#level_path = levels[current_level_index]
	#current_state = GameState.GAMEPLAY
	#get_tree().change_scene_to_file(level_path)
	
func _start_level(level_index: int):
	if level_unlocked[level_index]:
		current_level_index = level_index
		current_state = GameState.GAMEPLAY
		var level_path = levels[current_level_index]
		get_tree().change_scene_to_file(level_path)
	else:
		print("Level is locked!")

#func _on_level_complete():
	#current_level_index += 1
	#_go_to_level_select()

func _on_level_complete():
	# Unlock the next level if it exists
	if current_level_index + 1 < level_unlocked.size():
		level_unlocked[current_level_index + 1] = true
	
	current_level_index += 1
	_go_to_level_select()

	
	# Optionally return to level select or reset the game for replay
	#_reset_game()
	


func _test_shapes():
	# Create some testing shapes, consisting of a 1x1 and a 2x1
	var shape1 = BuildingShape.new()
	shape1.root.direction = BuildingBlock.Direction.LEFT

	var shape2 = BuildingShape.new()
	shape2.root.direction = BuildingBlock.Direction.RIGHT
	
	var block = BuildingBlock.new()
	block.direction = BuildingBlock.Direction.LEFT
	shape2.blocks[Vector2i(0, 1)] = block

	level_shapes[0].shapes.append(shape1)
	level_shapes[0].shapes.append(shape2)
	
func get_direction_from_string(direction_str):
	match direction_str:
		"left":
			return BuildingBlock.Direction.LEFT
		"right":
			return BuildingBlock.Direction.RIGHT
		"up":
			return BuildingBlock.Direction.UP
		"down":
			return BuildingBlock.Direction.DOWN
		_:
			return BuildingBlock.Direction.NONE

func get_shapes_for_level() -> Array:
	var shapes = []
	var current_level_data = level_data[current_level_index]
	var shape_data = current_level_data["shapes"]
	
	for shape_tuple_list in shape_data:
		var shape = BuildingShape.new()
		
		var root_tuple = shape_tuple_list[0]
		shape.root.direction = get_direction_from_string(root_tuple[0])
		
		for i in range(1, shape_tuple_list.size()):
			var block_tuple = shape_tuple_list[i]
			print(block_tuple)
			var block = BuildingBlock.new()
			block.direction = get_direction_from_string(block_tuple[0])
			shape.blocks[Vector2i(block_tuple[1], block_tuple[2])] = block
		print(shape.blocks)
		shapes.append(shape)
	
	return shapes

func get_multipliers_for_level() -> Array:
	var current_level_data = level_data[current_level_index]
	var mult_data = current_level_data["multipliers"]
	
	return mult_data
