extends Control

var multipliers = []
@onready var shape_container = $Panel/HBoxContainer
const AVAILABLE_MULTIPLIER = preload("res://scenes/available_multiplier.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Testing multipliers
	multipliers.append(2)
	multipliers.append(3)

	_draw_multiplier_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw_multiplier_ui():
	for multiplier in multipliers:
		var new_multiplier = AVAILABLE_MULTIPLIER.instantiate()
		new_multiplier.multiplier = multiplier
		shape_container.add_child(new_multiplier)
