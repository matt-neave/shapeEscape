extends Control

var shapes = []
@onready var shape_container = $Panel/HBoxContainer
const AVAILABLE_SHAPE = preload("res://scenes/available_shape.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create some testing shapes, consisting of a 1x1 and a 2x1
	var shape1 = BuildingShape.new()
	shape1.root.direction = BuildingBlock.Direction.LEFT

	var shape2 = BuildingShape.new()
	shape2.root.direction = BuildingBlock.Direction.RIGHT
	var block = BuildingBlock.new()
	block.direction = BuildingBlock.Direction.LEFT
	shape2.blocks[Vector2i(0, 1)] = block

	shapes.append(shape1)
	shapes.append(shape2)

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
