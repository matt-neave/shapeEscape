extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Function called when another body enters the trigger area
func _on_LevelCompleteTrigger_body_entered(body):
	if body.name == "Player":  # Assuming your player character's name is "Player"
		GameManager._on_level_complete()  # Call the level complete function

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
