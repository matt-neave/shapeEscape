extends TileMap

@export var shapes_control: Control
@onready var tile_particles = $"../TileParticles"

const PLACEMENT_PARTICLES = preload("res://particles/placement_particles.tscn")
const RETRY_PARTICLES = preload("res://particles/retry_particles.tscn")
var shape
var active_shapes = []

var placement_mode = false
var prev_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("tile_control")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Check if the primary action button is pressed and place a tile
	if Input.is_action_just_released("primary") && placement_mode:
		_place_shape()

	if Input.is_action_just_pressed("secondary"):
		_check_scale_shape()
		
	if placement_mode:
		_placement()

func _place_shape():
	var mouse_pos = get_global_mouse_position()
	var cell_pos = local_to_map(mouse_pos)
	
	if shapes_control.mouse_over:
		placement_mode = false
		return
	
	if !get_used_cells(0).has(cell_pos) and !get_used_cells(1).has(cell_pos):
		_place_shape_at_root(cell_pos)
		SoundManager.play_sound(SoundManager.SOUNDS.TILE_PLACE)
		placement_mode = false
	
	
func enter_placement_mode(shape):
	self.shape = shape
	placement_mode = true
	
func exit_placement_mode(shape, shape_ui):
	if !shapes_control.mouse_over: # if shape is successfully placed
		shape_ui.expire()
	placement_mode = false
	_clear_placement_cells()

func multiplier_dropped(scale, multiplier_ui):
	_check_scale_shape(scale, multiplier_ui)

func _place_shape_at_root(cell_pos):
	shape.global_position = cell_pos
	# Add the root and other blocks to the tilemap	
	set_cell(1, cell_pos, 0, Vector2i(0, 0))

	for block_pos in shape.blocks.keys():
		var global_pos = cell_pos + block_pos
		_place_block(global_pos, shape.blocks[block_pos])
	active_shapes.append(shape)

func _check_scale_shape(scale=1, multiplayer_ui = null):
	var mouse_pos = get_global_mouse_position()
	var cell_pos = local_to_map(mouse_pos)
	if get_used_cells(1).has(cell_pos):
		# Fine the shape that is being scaled, this could be the shape root, or any of the blocks
		var shape_to_scale = null
		for active_shape in active_shapes:
			for block_pos in active_shape.blocks.keys():
				if active_shape.global_position + block_pos == cell_pos:
					shape_to_scale = active_shape
					break
		
		if shape_to_scale != null:
			if multiplayer_ui:
				multiplayer_ui.expire()
			_scale_shape(shape_to_scale, scale)

func _scale_shape(shape, scale):
	var new_blocks = {}

	# Project each block (including the root) by the scale in the direction of the block
	for block_pos in shape.blocks.keys():
		var block = shape.blocks[block_pos]
		var global_pos = shape.global_position + block_pos
		
		match block.direction:
			BuildingBlock.Direction.NONE:
				pass
			BuildingBlock.Direction.UP:
				block.direction = BuildingBlock.Direction.NONE
				for i in range(scale):
					new_blocks[block_pos - Vector2i(0, i)] = block
					_place_block(global_pos - Vector2i(0, i), block)
			BuildingBlock.Direction.DOWN:
				block.direction = BuildingBlock.Direction.NONE
				for i in range(scale):
					new_blocks[block_pos + Vector2i(0, i)] = block
					_place_block(global_pos + Vector2i(0, i), block)
			BuildingBlock.Direction.LEFT:
				block.direction = BuildingBlock.Direction.NONE
				for i in range(scale):
					new_blocks[block_pos - Vector2i(i, 0)] = block
					_place_block(global_pos - Vector2i(i, 0), block)
			BuildingBlock.Direction.RIGHT:
				block.direction = BuildingBlock.Direction.NONE
				for i in range(scale):
					new_blocks[block_pos + Vector2i(i, 0)] = block
					_place_block(global_pos + Vector2i(i, 0), block)

	shape.blocks = new_blocks
	SoundManager.play_sound(SoundManager.SOUNDS.TILE_PLACE)

func _place_block(global_pos, block, layer=1):
	match block.direction:
		BuildingBlock.Direction.NONE:
			set_cell(layer, global_pos, 0, Vector2i(0, 2))
		BuildingBlock.Direction.UP:
			set_cell(layer, global_pos, 0, Vector2i(0, 1))
		BuildingBlock.Direction.DOWN:
			set_cell(layer, global_pos, 0, Vector2i(1, 0))
		BuildingBlock.Direction.LEFT:
			set_cell(layer, global_pos, 0, Vector2i(1, 1))
		BuildingBlock.Direction.RIGHT:
			set_cell(layer, global_pos, 0, Vector2i(0, 0))

func _placement():
	var mouse_pos = get_global_mouse_position()
	var cell_pos = local_to_map(mouse_pos)
	
	_clear_placement_cells()
	for block_pos in shape.blocks.keys():
		var global_pos = cell_pos + block_pos
		_place_block(global_pos, shape.blocks[block_pos], 2)
		
	prev_pos = cell_pos

func _clear_placement_cells():
	clear_layer(2)
	
func _reset_cell(pos, layer=2):
	set_cell(layer, pos, 0, Vector2i(3,3))

func _reset():
	clear_layer(1)
	
	for active_shape in active_shapes:
		var retry_particles = RETRY_PARTICLES.instantiate()
		retry_particles.global_position = map_to_local(active_shape.global_position)
		add_child(retry_particles)
		retry_particles.emitting = true
	active_shapes = []
	
