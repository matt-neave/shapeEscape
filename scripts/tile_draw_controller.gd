extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Check if the primary action button is pressed and place a tile
	if Input.is_action_pressed("primary"):
		var mouse_pos = get_global_mouse_position()
		print(mouse_pos)
		var cell_pos = local_to_map(mouse_pos)
		print(cell_pos)
		if !get_used_cells(0).has(cell_pos):
			set_cell(0, cell_pos, 0, Vector2i(0, 0))
			SoundManager.play_sound(SoundManager.SOUNDS.TILE_PLACE)
