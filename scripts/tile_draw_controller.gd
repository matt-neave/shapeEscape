extends TileMap

var shapes = []
var active_shapes = []

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Check if the primary action button is pressed and place a tile
	if Input.is_action_pressed("primary"):
		_place_shape()

	if Input.is_action_just_pressed("secondary"):
		_check_scale_shape()

func _place_shape():
	var mouse_pos = get_global_mouse_position()
	var cell_pos = local_to_map(mouse_pos)
	if !get_used_cells(0).has(cell_pos) and !get_used_cells(1).has(cell_pos):
		_place_shape_at_root(cell_pos)
		SoundManager.play_sound(SoundManager.SOUNDS.TILE_PLACE)

func _place_shape_at_root(cell_pos):
	if shapes.size() <= 0:
		return

	var shape = shapes[0]
	shape.global_position = cell_pos

	# Add the root and other blocks to the tilemap	
	set_cell(1, cell_pos, 0, Vector2i(0, 0))

	for block_pos in shape.blocks.keys():
		var global_pos = cell_pos + block_pos
		set_cell(1, global_pos, 0, Vector2i(0, 0))
	active_shapes.append(shape)
	shapes.pop_front()

func _check_scale_shape():
	var scale = 2
	var mouse_pos = get_global_mouse_position()
	var cell_pos = local_to_map(mouse_pos)
	if get_used_cells(1).has(cell_pos):
		# Fine the shape that is being scaled, this could be the shape root, or any of the blocks
		var shape = null
		for active_shape in active_shapes:
			for block_pos in active_shape.blocks.keys():
				if active_shape.global_position + block_pos == cell_pos:
					shape = active_shape
					break
		
		if shape != null:
			_scale_shape(shape, scale)

func _scale_shape(shape, scale):
	# Project each block (including the root) by the scale in the direction of the block
	for block_pos in shape.blocks.keys():
		var block = shape.blocks[block_pos]
		var global_pos = shape.global_position + block_pos
		
		match block.direction:
			BuildingBlock.Direction.NONE:
				break
			BuildingBlock.Direction.UP:
				for i in range(scale):
					set_cell(1, global_pos + Vector2i(0, i), 0, Vector2i(0, 0))
			BuildingBlock.Direction.DOWN:
				for i in range(scale):
					set_cell(1, global_pos - Vector2i(0, i), 0, Vector2i(0, 0))
			BuildingBlock.Direction.LEFT:
				for i in range(scale):
					set_cell(1, global_pos - Vector2i(i, 0), 0, Vector2i(0, 0))
			BuildingBlock.Direction.RIGHT:
				for i in range(scale):
					set_cell(1, global_pos + Vector2i(i, 0), 0, Vector2i(0, 0))
	
