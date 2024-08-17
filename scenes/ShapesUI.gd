#extends VBoxContainer  # Or HBoxContainer, depending on your layout preference
#
#var shapes = []
#var active_shapes = []
#
#var placement_mode = false
#var prev_pos
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	## Create some testing shapes, consisting of a 1x1 and a 2x1
	#var shape1 = BuildingShape.new()
	#shape1.root.direction = BuildingBlock.Direction.LEFT
#
	#var shape2 = BuildingShape.new()
	#shape2.root.direction = BuildingBlock.Direction.RIGHT
	#var block = BuildingBlock.new()
	#block.direction = BuildingBlock.Direction.LEFT
	#shape2.blocks[Vector2i(0, 1)] = block
#
	#shapes.append(shape1)
	#shapes.append(shape2)
#
	## Generate the UI for the shapes
	#update_shapes_ui()
#
## Clears all the existing UI elements in the container
#func clear_shapes():
	#for child in get_children():
		#child.queue_free()
#
## Update the UI for each BuildingShape
#func update_shapes_ui():
	#clear_shapes()
	#for shape in shapes:
		#create_shape_ui(shape)
#
## Create the UI for each BuildingShape
#func create_shape_ui(shape: BuildingShape):
	#var shape_container = Control.new()
	#shape_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#shape_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
#
	## Iterate through each block in the shape and create a visual representation
	#for local_pos in shape.blocks.keys():
		#var block = shape.blocks[local_pos]
		#var block_sprite = TextureRect.new()
#
		## Get the texture from the atlas based on block direction and coordinates
		#block_sprite.texture = get_block_texture(block)
		#block_sprite.rect_min_size = Vector2(32, 32)  # Standard block size
#
		## Position the block in the shape UI based on its local position
		#block_sprite.rect_position = local_pos * 32  # Assuming each block is 32x32 pixels
#
		#shape_container.add_child(block_sprite)
		#
	#shape_container.connect("gui_input", self, "_on_shape_ui_drag", [shape])
#
	#add_child(shape_container)
#
## Function to get the appropriate texture from the atlas based on the block's direction
#func get_block_texture(block: BuildingBlock) -> AtlasTexture:
	#var atlas_texture = AtlasTexture.new()
	#atlas_texture.atlas = preload("res://assets/tiles/block_tileset.png")  # Replace with your atlas path
#
	#match block.direction:
		#BuildingBlock.Direction.UP:
			#atlas_texture.region = Rect2(Vector2(1, 0) * 32, Vector2(32, 32))  # Adjust coordinates as needed
		#BuildingBlock.Direction.DOWN:
			#atlas_texture.region = Rect2(Vector2(0, 1) * 32, Vector2(32, 32))
		#BuildingBlock.direction.LEFT:
			#atlas_texture.region = Rect2(Vector2(1, 1) * 32, Vector2(32, 32))
		#BuildingBlock.Direction.RIGHT:
			#atlas_texture.region = Rect2(Vector2(0, 0) * 32, Vector2(32, 32))
		#BuildingBlock.Direction.NONE:
			#atlas_texture.region = Rect2(Vector2(0, 2) * 32, Vector2(32, 32))
#
	#return atlas_texture
#
## Function to handle dragging shapes from the UI
#func _on_shape_ui_drag(event, shape: BuildingShape):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#var drag_instance = Sprite2D.new()
#
		## Generate a combined texture for the shape or set it up here
		#drag_instance.texture = generate_combined_texture(shape)
		#drag_instance.position = event.global_position
		#get_tree().root.add_child(drag_instance)  # Add it to the root so it can be moved freely
#
		#drag_instance.connect("gui_input", self, "_on_drag_instance_gui_input", [drag_instance, shape])
##
## Function to generate a combined texture for the shape (optional)
#func generate_combined_texture(shape: BuildingShape) -> Texture:
	## This function creates a combined texture for dragging
	## Placeholder implementation:
	#var texture = ImageTexture.new()
	#texture.load("res://path_to_placeholder_texture.png")  # Replace with actual implementation
	#return texture
#
## Function to handle the drag instance's input
#func _on_drag_instance_gui_input(event, drag_instance: Sprite2D, shape: BuildingShape):
	#if event is InputEventMouseMotion:
		#drag_instance.position = event.global_position
	#elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		#place_shape_on_tilemap(shape, drag_instance.global_position)
		#drag_instance.queue_free()
#
## Function to place the shape on the tilemap
#func place_shape_on_tilemap(shape: BuildingShape, global_pos: Vector2):
	#var tilemap = get_tree().root.get_node("MainScene/TileMap")
	#var cell_pos = tilemap.local_to_map(global_pos)
	#
	## Iterate through each block in the shape and place it on the tilemap
	#for local_pos in shape.blocks.keys():
		#var block_pos = cell_pos + local_pos
		#var block = shape.blocks[local_pos]
		#tilemap.set_cell(1, block_pos, 0, get_block_texture(block).region_position / 32)  # Adjust the layer and index as needed
