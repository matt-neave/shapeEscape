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

		if block_pos.x < min_x:
			min_x = block_pos.x
		if block_pos.y < min_y:
			min_y = block_pos.y
		if block_pos.x > max_x:
			max_x = block_pos.x
		if block_pos.y > max_y:
			max_y = block_pos.y

		add_child(sprite)
	
	var to_scale = max(max_x - min_x + 1, max_y - min_y + 1)
	scale.x /= to_scale
	scale.y /= to_scale

	# By default, the pivot is the root block
	# We need to shift the pivot to the center of the shape
	var center = Vector2((max_x + min_x) / 2, (max_y + min_y) / 2)
	position = -center * 64 * scale

	# Finally, move to the center of the container
	position += get_parent().get_parent().size / 2
	
	

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
