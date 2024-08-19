extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -750.0
@onready var camera_2d: Camera2D = $Camera2D
@onready var animation_player = $Body/AnimationPlayer
@onready var running_particles = $RunningParticles
@onready var jumping_particles = $JumpingParticles

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Attempt to find a spawn point in the scene
	var spawn_point = get_parent().get_node_or_null("SpawnPoint")
	if spawn_point:
		global_position = spawn_point.global_position  # Set player's position to the spawn point
	
	_adjust_camera_limits()
	camera_2d.make_current()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * 2 * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_player.play("jump")
		jumping_particles.emitting = true
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	_sprite_direction()
	_run_animation()
	move_and_slide()

func _adjust_camera_limits():
	# Set the camera limits to the tilemap's used rect.
	var tilemap: TileMap = get_parent().get_node("TileMap")
	var rect = tilemap.get_used_rect()
	# Scale by the tile size.
	rect.size *= tilemap.tile_set.tile_size
	rect.position *= tilemap.tile_set.tile_size
	camera_2d.limit_left = rect.position.x
	camera_2d.limit_right = rect.position.x + rect.size.x
	camera_2d.limit_top = rect.position.y
	camera_2d.limit_bottom = rect.position.y + rect.size.y
	print(rect)
	print(camera_2d.limit_bottom)

func _sprite_direction():
	if velocity.x < 0:
		$Body.scale.x = - abs($Body.scale.x)
	elif velocity.x > 0:
		$Body.scale.x = abs($Body.scale.x)

func _run_animation():
		
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		animation_player.play("run")
		if is_on_floor():
			SoundManager.play_sound(SoundManager.SOUNDS.FOOT_STEP, Vector2.ZERO, 10, true)
	elif is_on_floor() and velocity.x == 0:
		SoundManager.kill_sound(SoundManager.SOUNDS.FOOT_STEP)
		animation_player.play("idle")
		
	if is_on_floor() and velocity.x != 0:
		running_particles.emitting = true
	else:
		running_particles.emitting = false
