extends Control

var multipliers = []
@onready var shape_container = $Panel/ScrollContainer/HBoxContainer
const AVAILABLE_MULTIPLIER = preload("res://scenes/available_multiplier.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	fetch_ui_data()
	add_to_group("ui_control")

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
