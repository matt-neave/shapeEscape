extends Area2D

@onready var basic_block = $BasicBlock
@onready var animation_player = $BasicBlock/AnimationPlayer

const BLOCK_INITIAL_COLOR = Color(0.84, 0.66, 0.94)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Function called when another body enters the trigger area
func _on_LevelCompleteTrigger_body_entered(body):
	if body.name == "Player":  # Assuming your player character's name is "Player"
		SoundManager.play_sound(SoundManager.SOUNDS.LEVEL_COMPLETE, Vector2.ZERO)
		get_parent().get_node("LevelComplete").show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
