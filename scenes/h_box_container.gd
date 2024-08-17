extends HBoxContainer

var shapes = []  # This will be populated by the TileMap script

# Called when the node enters the scene tree for the first time.
func _ready():
	place_shapes_in_container()

func place_shapes_in_container():
	# Clear any existing children in the container
	for child in get_children():
		remove_child(child)
		child.queue_free()


	# Iterate over the shapes array and create UI elements for each shape
	for shape in shapes:
		var shape_container = Control.new()
		shape_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		shape_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		# Iterate through each block in the shape and create a visual representation
		for local_pos in shape.blocks.keys():
			var block = shape.blocks[local_pos]
			var block_sprite = TextureRect.new()

			# Get the texture from the atlas based on block direction and coordinates
			block_sprite.texture = get_block_texture(block)
			block_sprite.custom_minimum_size = block_sprite.texture.get_size()

			# Position the block inside the container
			block_sprite.position = Vector2(local_pos.x, local_pos.y) * block_sprite.texture.get_size()

			shape_container.add_child(block_sprite)
		
		add_child(shape_container)
	
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER


func get_block_texture(block: BuildingBlock) -> AtlasTexture:
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = preload("res://assets/tiles/block_tileset.png")  # Replace with your atlas path

	match block.direction:
		BuildingBlock.Direction.UP:
			atlas_texture.region = Rect2(Vector2(1, 0) * 64, Vector2(64, 64))
		BuildingBlock.Direction.DOWN:
			atlas_texture.region = Rect2(Vector2(0, 1) * 64, Vector2(64, 64))
		BuildingBlock.Direction.LEFT:
			atlas_texture.region = Rect2(Vector2(1, 1) * 64, Vector2(64, 64))
		BuildingBlock.Direction.RIGHT:
			atlas_texture.region = Rect2(Vector2(0, 0) * 64, Vector2(64, 64))
		BuildingBlock.Direction.NONE:
			atlas_texture.region = Rect2(Vector2(0, 2) * 64, Vector2(64, 64))

	return atlas_texture
