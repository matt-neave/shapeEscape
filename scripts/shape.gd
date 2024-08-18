extends Resource
class_name BuildingShape

# A shape is a collection of building blocks
# A shape has a root, which has a local position of (0, 0)
# Each non-root node has a local position relative to the root
# The shape has a position, which is the global position of the shape in the tilemap

@export var global_position: Vector2i = Vector2i(0, 0)
@export var root: BuildingBlock = BuildingBlock.new()
@export var blocks: Dictionary = {
	Vector2i(0, 0): root
}
@export var color: Color = Color(0,0,0)
func size():
	return blocks.size()
