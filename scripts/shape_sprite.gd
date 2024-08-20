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

		# Scale the shape to fit the sprite
		# We need to calculate the center of the sprites
		# And the width and height they occupy, to scale down


	
func draw_shape():
	# Draws a shape, using sprites from the shape node
	# Create a new sprite for each block in the shape
	# While drawing, we track the corners of the shape to scale it down
	var min_x = 0
	var min_y = 0
	var max_x = 0
	var max_y = 0

	for block_pos in shape.blocks.keys():
		var block = shape.blocks[block_pos]
		var sprite = Sprite2D.new()
		sprite.texture = get_block_texture(block)
		sprite.position = block_pos * 64
		add_child(sprite)

		min_x = min(min_x, block_pos.x)
		min_y = min(min_y, block_pos.y)
		max_x = max(max_x, block_pos.x)
		max_y = max(max_y, block_pos.y)

	var shape_width = (max_x - min_x + 1) * 64
	var shape_height = (max_y - min_y + 1) * 64

	var parent_size = get_parent().get_parent().size
	var scale_factor = min(parent_size.x / shape_width, parent_size.y / shape_height)
	
	# Additional scaling to ensure that there is some room near the boundaries
	var margin_scale_factor = 0.8
	scale_factor *= margin_scale_factor
	scale = Vector2(scale_factor, scale_factor)

	# Calculate the center
	var shape_center = Vector2((max_x + min_x) * 32, (max_y + min_y) * 32) * scale_factor

	# Position the shape to center
	position = (parent_size / 2) - shape_center
	
	

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
