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
		"multipliers" = [],
		"unlocked" = true
	},
	{
		"shapes" = [
			[["right", 0, 0]],
		],
		"multipliers" = [4],
		"unlocked" = false
	},
	{
		"shapes" = [
			[["none", 0, 0], ["up", 1, 0]],
		],
		"multipliers" = [3],
		"unlocked" = false
	},
	{ # level 4
		"shapes" = [
			[["none", 0, 0], ["left", 0, 1], ["none", 1, 0]],
			[["right", 0, 0]],
		],
		"multipliers" = [2, 2],
		"unlocked" = true
	},
	{ # level 5
		"shapes" = [
			[["none", 0, 0], ["up", 2, 4]],
			[["none", 0, 0], ["none", -1, -1], ["none", 1, 1]],
			[["right", 0, 0], ["left", 3, 1]],
		],
		"multipliers" = [3],
		"unlocked" = true,
	},
	{ # level 6
		"shapes" = [
			[["up", 0, 0], ["none", 1, -3]],
			[["right", 0, 0]],
			[["none", 0, 0], ["none", 2, 1], ["none", 2, 2]],
			[["none", 0, 0], ["none", 0, 1]],
		],
		"multipliers" = [2, 3],
		"unlocked" = true,
	},
	{ # level 7
		"shapes" = [
			[["none", 0, 0], ["up", 6, 0]],
			[["up", 0, 0]], 
			[["right", 0, 0], ["left", 9, 0]],

		],
		"multipliers" = [3, 4, 5],
		"unlocked" = true,
	},
	{ # level 8
		"shapes" = [
			[["up", 0, 0], ["none", 1, 0]],
			[["none", 0, 0], ["up", 1, 0]],
			[["right", 0, 0], ["left", 2, 2]],
			[["up", 0, 0], ["up", 3, -2]],
			[["none", 0, 0], ["left", 0, 1]],
			[["none", 0, 0]]
		],
		"multipliers" = [2, 3, 3, 3, 4],
		"unlocked" = true,
	},
	{ # level 9
		"shapes" = [
			[["left", 0, 0], ["right", 2, 0]],
			[["up", 0, 0], ["none", 1, 0], ["up", 1, -1]],
			[["right", 0, 0], ["left", 1, 1]],
			[["right", 0, 0], ["up", 1, 2]],
		],
		"multipliers" = [2, 3, 3, 3],
		"unlocked" = false,
	},
	{ # level 10
		"shapes" = [
			[["right", 0, 0], ["up", -1, 0], ["up", 3, 0]],
			[["none", 0, 0], ["none", 0, -1], ["none", 0, 1]],
			[["up", 0, 0], ["up", -1, 1], ["up", 1, -1]],
		],
		"multipliers" = [3, 3],
		"unlocked" = false,
	},
	{ # level 11
		"shapes" = [
			[["up", 0, 0], ["down", -1, -1], ["down", 1, -1]],
			[["up", 0, 0], ["up", -1, 0], ["up", 1, 0]],
			[["up", 0, 0], ["up", -2, 1], ["up", 2, -1]],
			[["up", 0, 0], ["up", -1, -2]],
			[["left", 0, 0], ["right", -5, 2], ["right", -5, -2]],
			[["none", 0, 0], ["none", 5, -3]],

		],
		"multipliers" = [2, 2, 3, 3, 3],
		"unlocked" = false,
	},
	#{ Level X
		#"shapes" = [
			#[["left", 0, 0]],
			#[["right", 0, 0]],
			#[["right", 0, 0], ["left", 2, -1]],
		#],
		#"multipliers" = [2, 2, 3, 2, 2, 2],
		#"unlocked" = false
	#},
]

var level = 0
var levels = ["res://scenes/sample_world.tscn"]
var current_level_index = 0
var current_state: GameState = GameState.MENU
var total_time = 0.0
var level_time = 0.0

func unlock_next_level():
	if current_level_index + 1 < level_data.size():
		level_data[current_level_index + 1]["unlocked"] = true

func get_unlocked_levels() -> int:
	for i in range(level_data.size()):
		if !level_data[i]["unlocked"]:
			return i
	return level_data.size()  # All levels are unlocked

func _ready():
	_test_shapes()
	_go_to_menu()
	SoundManager.play_music(SoundManager.SOUNDS.BUILD_MUSIC)

func _process(delta):
	total_time += delta
	if current_state == GameState.GAMEPLAY:
		level_time += delta

func _go_to_menu():
	current_state = GameState.MENU
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _go_to_level_select():
	current_state = GameState.LEVEL_SELECT
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

#func _start_level(level_path: String):
	#level_path = levels[current_level_index]
	#current_state = GameState.GAMEPLAY
	#get_tree().changnext_levele_scene_to_file(level_path)
	
func _start_level(level_index: int):
	level_time = 0.0
	if level_data[level_index]["unlocked"]:
		current_level_index = (level_index)
		current_state = GameState.GAMEPLAY
		var level_path = levels[current_level_index]
		get_tree().change_scene_to_file(level_path)
	else:
		print("Level is locked!")

func _on_level_complete():
	GameManager.unlock_next_level()
	load_next_level()

func load_next_level():
	level_time = 0.0
	current_level_index += 1
	current_state = GameState.GAMEPLAY
	if current_level_index < level_data.size():
		var scene_path = "res://scenes/levels/level_%d.tscn" % (current_level_index + 1)
		get_tree().change_scene_to_file(scene_path)
	else:
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")

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
			var block = BuildingBlock.new()
			block.direction = get_direction_from_string(block_tuple[0])
			shape.blocks[Vector2i(block_tuple[1], block_tuple[2])] = block
		shapes.append(shape)
	
	return shapes

func get_multipliers_for_level() -> Array:
	var current_level_data = level_data[current_level_index]
	var mult_data = current_level_data["multipliers"]
	
	return mult_data
