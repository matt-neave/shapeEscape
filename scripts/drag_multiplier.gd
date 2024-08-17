extends Button

var initial_global_position
var movement: bool = false
var multiplier_value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	if movement && Input.is_action_just_released("primary"):
		get_tree().call_group("tile_control", "multiplier_dropped", multiplier_value)
		movement = false
		get_parent().global_position = initial_global_position
		

	if movement:
		var mouse_position = get_global_mouse_position()
		# Set parent center to mouse position
		var parent = get_parent()
		parent.global_position = mouse_position - size / 2



func _on_button_down():
	movement = true
	initial_global_position = get_parent().global_position
