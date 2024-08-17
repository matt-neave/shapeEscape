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
var level = 0
var levels = ["res://scenes/sample_world.tscn"]
var current_level_index = 0

var current_state: GameState = GameState.MENU

func _ready():
	_test_shapes()
	_go_to_menu()

func _go_to_menu():
	current_state = GameState.MENU
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _go_to_level_select():
	current_state = GameState.LEVEL_SELECT
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _start_level(level_path: String):
	level_path = levels[current_level_index]
	current_state = GameState.GAMEPLAY
	get_tree().change_scene_to_file(level_path)

func _on_level_complete():
	current_level_index += 1
	_go_to_level_select()
	
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
