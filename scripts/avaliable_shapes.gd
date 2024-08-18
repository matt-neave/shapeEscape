extends Control

@onready var shape_container = $Panel/HBoxContainer
var shapes = []
var mouse_over: bool = false
const AVAILABLE_SHAPE = preload("res://scenes/available_shape.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	fetch_ui_data()
	add_to_group("ui_control")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw_available_shapes():
	for shape in shapes:
		var new_shape = AVAILABLE_SHAPE.instantiate()
		new_shape.shape = shape
		shape_container.add_child(new_shape)

func fetch_ui_data():
	for child in shape_container.get_children():
		child.queue_free()
		
	shapes = GameManager.get_shapes_for_level()
	_draw_available_shapes()

func _on_panel_mouse_entered():
	mouse_over = true

func _on_panel_mouse_exited():
	mouse_over = false
