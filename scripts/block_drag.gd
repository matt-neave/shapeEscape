extends Button

var initial_global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func expire():
	get_tree().call_deferred("call_group", "undo_shape", "push_back_shape", get_parent().shape)
	get_parent().call_deferred("queue_free")

func _process(_delta):
	if !get_parent().visible && Input.is_action_just_released("primary"):
		get_parent().visible = true
		get_tree().call_group("tile_control", "exit_placement_mode", get_parent().shape, self)
		
func _on_button_down():
	get_parent().visible = false
	get_tree().call_group("tile_control", "enter_placement_mode", get_parent().shape)
