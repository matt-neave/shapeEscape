extends Node

enum GameState {
	MENU,
	LEVEL_SELECT,
	GAMEPLAY
}

var levels = ["res://scenes/sample_world.tscn"]
var current_level_index = 0

var current_state: GameState = GameState.MENU

func _ready():
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
