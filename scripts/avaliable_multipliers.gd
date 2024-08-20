extends Control

var multipliers = []
@onready var shape_container = $Panel/ScrollContainer/HBoxContainer
const AVAILABLE_MULTIPLIER = preload("res://scenes/available_multiplier.tscn")
var undo_stack = []

# Called when the node enters the scene tree for the first time.
func _ready():
	fetch_ui_data()
	add_to_group("ui_control")
	add_to_group("undo_mp")

func push_back_mp(mp):
	undo_stack.push_back(mp)

func undo():
	print("undid")
	if undo_stack.size() > 0:
		var undo_multiplier = undo_stack.pop_back()
		var new_multiplier = AVAILABLE_MULTIPLIER.instantiate()
		new_multiplier.multiplier = undo_multiplier
		shape_container.add_child(new_multiplier)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw_multiplier_ui():
	multipliers.sort()
	for multiplier in multipliers:
		var new_multiplier = AVAILABLE_MULTIPLIER.instantiate()
		new_multiplier.multiplier = multiplier
		shape_container.add_child(new_multiplier)

func fetch_ui_data():
	for child in shape_container.get_children():
		child.queue_free()
		
	multipliers = GameManager.get_multipliers_for_level()
	_draw_multiplier_ui()
