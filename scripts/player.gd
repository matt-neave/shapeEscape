extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -375.0
@onready var camera_2d: Camera2D = $Camera2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Attempt to find a spawn point in the scene
	var spawn_point = get_parent().get_node_or_null("SpawnPoint")
	if spawn_point:
		global_position = spawn_point.global_position  # Set player's position to the spawn point
	
	# Set the camera limits to the tilemap's used rect.
	var tilemap: TileMap = get_parent().get_node("TileMap")
	var rect = tilemap.get_used_rect()
	# Scale by the tile size.
	rect.size *= tilemap.tile_set.tile_size
	rect.position *= tilemap.tile_set.tile_size
	print(rect)
	camera_2d.limit_left = rect.position.x
	camera_2d.limit_right = rect.position.x + rect.size.x
	camera_2d.limit_top = rect.position.y
	camera_2d.limit_bottom = rect.position.y + rect.size.y


	camera_2d.make_current()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * 2 * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * 2

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
