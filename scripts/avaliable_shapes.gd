extends Control

var shapes = []
@onready var shape_container = $Panel/HBoxContainer
const AVAILABLE_SHAPE = preload("res://scenes/available_shape.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	shapes = GameManager.get_shapes_for_level()
	_draw_available_shapes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw_available_shapes():
	print(shapes)
	for shape in shapes:
		var new_shape = AVAILABLE_SHAPE.instantiate()
		new_shape.shape = shape
		shape_container.add_child(new_shape)
