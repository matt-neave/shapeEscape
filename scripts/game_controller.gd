extends Node

var levels = [
	{
		"shapes": []
	}
]
var level = 0

func _ready():
	# Create some testing shapes, consisting of a 1x1 and a 2x1
	var shape1 = BuildingShape.new()
	shape1.root.direction = BuildingBlock.Direction.LEFT

	var shape2 = BuildingShape.new()
	shape2.root.direction = BuildingBlock.Direction.RIGHT
	var block = BuildingBlock.new()
	block.direction = BuildingBlock.Direction.LEFT
	shape2.blocks[Vector2i(0, 1)] = block

	levels[0].shapes.append(shape1)
	levels[0].shapes.append(shape2)

func _process(_delta):
	pass
	
