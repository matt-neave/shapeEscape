extends Button

var initial_global_position
var movement: bool = false
var multiplier_value = 0
var prev_parent
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func expire():
	get_tree().call_deferred("call_group", "undo_mp", "push_back_mp", multiplier_value)
	get_parent().call_deferred("queue_free")

func _process(_delta):
	if movement && Input.is_action_just_released("primary"):
		get_tree().call_group("tile_control", "multiplier_dropped", multiplier_value, self)
		movement = false
		get_parent().reparent(prev_parent)

	if movement:
		var mouse_position = get_global_mouse_position()
		# Set parent center to mouse position
		var parent = get_parent()
		parent.global_position = mouse_position - size / 2



func _on_button_down():
	movement = true
	prev_parent = get_parent().get_parent()
	get_parent().reparent(get_parent().get_parent().get_parent().get_parent())
