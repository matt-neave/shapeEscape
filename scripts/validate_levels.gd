# LevelValidator.gd
@tool
extends Node

# Function to check if the level is solvable
func is_level_solvable(tilemap, blocks, multipliers):
	var start = find_start_position(tilemap)
	var end = find_end_position(tilemap)
	
	return solve(start, end, blocks, multipliers, tilemap)

# Recursive function to attempt to solve the level
func solve(current_position, end_position, blocks, multipliers, tilemap):
	if current_position == end_position:
		return true  # Reached the goal
	
	for block in blocks:
		for multiplier in range(1, block.max_multiplier + 1):
			var scaled_block = scale_block(block, multiplier)
			var possible_positions = get_valid_positions(current_position, scaled_block, tilemap)
			
			for position in possible_positions:
				if can_place_block(position, scaled_block, tilemap):
					# Temporarily place the block
					place_block(position, scaled_block, tilemap)
					
					if solve(position, end_position, blocks, multipliers - 1, tilemap):
						return true  # Found a solution
					
					# Backtrack: remove the block and try another configuration
					remove_block(position, scaled_block, tilemap)
	
	return false  # No solution found

# Helper functions
# find_start_position, find_end_position, scale_block,
# get_valid_positions, can_place_block, place_block, remove_block

# Example helper function
func find_start_position(tilemap):
	# Logic to find the start position on the map
	return Vector2(0, 0)  # Example position

func find_end_position(tilemap):
	# Logic to find the end position on the map
	return Vector2(10, 10)  # Example position
