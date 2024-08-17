extends Resource
class_name BuildingBlock

# A building block is a single tile that can form a shape
# A building block has a direction, which is used to determine the projection of the tile

# The direction of the building block
enum Direction {
	NONE,
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var direction: Direction = Direction.RIGHT