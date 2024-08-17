extends Node2D
const BASIC_BLOCK = preload("res://assets/tiles/basic_block.png")
const BASIC_BLOCK_DOWN = preload("res://assets/tiles/basic_block_down.png")
const BASIC_BLOCK_LEFT = preload("res://assets/tiles/basic_block_left.png")
const BASIC_BLOCK_RIGHT = preload("res://assets/tiles/basic_block_right.png")
const BASIC_BLOCK_UP = preload("res://assets/tiles/basic_block_up.png")

var shape: BuildingShape:
	set(value):
		shape = value
		draw_shape()
		scale.x /= shape.size()
		scale.y /= shape.size()
	
func draw_shape():
	# Draws a shape, using sprites from the shape node
	# Create a new sprite for each block in the shape
	for block_pos in shape.blocks.keys():
		var block = shape.blocks[block_pos]
		var sprite = Sprite2D.new()
		sprite.texture = get_block_texture(block)
		sprite.position = block_pos * 64
		add_child(sprite)

func get_block_texture(block: BuildingBlock) -> Texture:
	match block.direction:
		BuildingBlock.Direction.UP:
			return BASIC_BLOCK_UP
		BuildingBlock.Direction.DOWN:
			return BASIC_BLOCK_DOWN
		BuildingBlock.Direction.LEFT:
			return BASIC_BLOCK_LEFT
		BuildingBlock.Direction.RIGHT:
			return BASIC_BLOCK_RIGHT
		_:
			return BASIC_BLOCK
