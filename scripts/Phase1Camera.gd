extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the camera limits to the tilemap's used rect.
	var tilemap: TileMap = get_parent().get_node("TileMap")
	var rect = tilemap.get_used_rect()
	# Scale by the tile size.
	rect.size *= tilemap.tile_set.tile_size
	rect.position *= tilemap.tile_set.tile_size
	limit_left = rect.position.x
	limit_right = rect.position.x + rect.size.x
	limit_top = rect.position.y
	
	# In bottom direciton, we account for UI
	limit_bottom = rect.position.y + rect.size.y + 80


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
