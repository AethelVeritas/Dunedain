extends Node

# Array to store grave positions
var grave_positions: Array[Vector2] = []

# Add a grave position
func add_grave_position(position: Vector2):
	grave_positions.append(position)

# Clear all grave positions (for when starting a new game)
func clear_graves():
	grave_positions.clear()

# Get all grave positions
func get_grave_positions() -> Array[Vector2]:
	return grave_positions.duplicate()
