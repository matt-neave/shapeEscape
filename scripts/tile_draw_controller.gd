extends TileMap

@export var shapes_control: Control
@onready var tile_particles = $"../TileParticles"
@onready var undo_button = $"../HUD/Undo"

const PLACEMENT_PARTICLES = preload("res://particles/placement_particles.tscn")
const RETRY_PARTICLES = preload("res://particles/block_destroy_particles.tscn")
var shape
var active_shapes = []
var undo_state = []
var undo_actions = []
var active_shapes_stack = []

var placement_mode = false
var prev_pos
var actions = []
# Called when the node enters the scene tree for the first time.
func _ready():
	undo_button.pressed.connect(undo)
	add_to_group("tile_control")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Check if the primary action button is pressed and place a tile
	# if Input.is_action_just_released("primary") && placement_mode:
	# 	_place_shape()
		
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
	
func _push_undo_stack():
	active_shapes_stack.append(active_shapes.duplicate())
	undo_state.append({
		Vector2i(0, 2): get_used_cells_by_id(1, -1, Vector2i(0, 2)),
		Vector2i(0, 0): get_used_cells_by_id(1, -1, Vector2i(0, 0)),
		Vector2i(1, 1): get_used_cells_by_id(1, -1, Vector2i(1, 1)),
		Vector2i(0, 1): get_used_cells_by_id(1, -1, Vector2i(0, 1)),
		Vector2i(1, 0): get_used_cells_by_id(1, -1, Vector2i(1, 0)),
	})

func undo():
	
	if undo_state.size() > 0:
		var undo_action = undo_actions.pop_back()
		if undo_action == "shape":
			get_tree().call_group("undo_shape", "undo")
		else:
			get_tree().call_group("undo_mp", "undo")
		SoundManager.play_sound(SoundManager.SOUNDS.TILE_PLACE)
		clear_layer(1)
		var state = undo_state.pop_back()
		for atlas_pos in state.keys():
			for cell in state[atlas_pos]:
				set_cell(1, cell, 0, atlas_pos)
		active_shapes = active_shapes_stack.pop_back()
func enter_placement_mode(shape):
	self.shape = shape
	placement_mode = true

func exit_placement_mode(shape, shape_ui):
	if !shapes_control.mouse_over and _can_place_shape_at_current_position():
		undo_actions.push_back("shape")
		_push_undo_stack()		
		_place_shape()
		shape_ui.expire()
	else:
		shape_ui.visible = true
	
	_clear_placement_cells()
	placement_mode = false

func _can_place_shape_at_current_position() -> bool:
	# Check if the cells where the shape would be placed are already occupied
	var mouse_pos = get_global_mouse_position()
	var cell_pos = local_to_map(mouse_pos)
	

	var used = _get_used_rect(0)	
	for block_pos in shape.blocks.keys():
		var global_pos = cell_pos + block_pos
		if get_used_cells(0).has(global_pos) or get_used_cells(1).has(global_pos):
			return false

		print(global_pos)
		if !used.has_point(global_pos):
			return false

	return true

func _get_used_rect(layer = 0):
	var used = get_used_cells(layer)
	var rect = Rect2()
	for cell in used:
		rect = rect.merge(Rect2(cell, Vector2(1, 1)))
	return rect

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
	undo_actions.append("scale")
	_push_undo_stack()

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
	var error_pos = false
	_clear_placement_cells()
	for block_pos in shape.blocks.keys():
		var global_pos = cell_pos + block_pos
		_place_block(global_pos, shape.blocks[block_pos], 2)

		if get_used_cells(0).has(global_pos) or get_used_cells(1).has(global_pos):
			error_pos = true
	
	if error_pos:
		# Modulate the layer 2
		set_layer_modulate(2, Color(1.0, 0.4, 0.4, 1.0))
	else:
		set_layer_modulate(2, Color(1, 1, 1, 0.5))
		
	prev_pos = cell_pos

func _clear_placement_cells():
	clear_layer(2)
	
func _reset_cell(pos, layer=2):
	set_cell(layer, pos, 0, Vector2i(3,3))

func _reset():
	for active_cell in get_used_cells(1):
		var retry_particles = RETRY_PARTICLES.instantiate()
		retry_particles.global_position = map_to_local(active_cell)
		add_child(retry_particles)
		retry_particles.emitting = true
	clear_layer(1)
	active_shapes = []
	undo_state = []
	undo_actions = []
	active_shapes_stack = []
	
