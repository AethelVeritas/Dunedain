extends Node

# Array to store grave positions
var grave_positions: Array[Vector2] = []

const GRAVE = preload("res://scenes/grave.tscn")

# Add a grave position and instantiate it immediately
func add_grave_position(position: Vector2):
	grave_positions.append(position)

	# Instantiate grave immediately in the current scene
	var current_scene = get_tree().current_scene
	if current_scene:
		var grave = GRAVE.instantiate()
		current_scene.add_child(grave)
		grave.global_position = position

# Clear all grave positions (for when starting a new game)
func clear_graves():
	grave_positions.clear()

# Get all grave positions
func get_grave_positions() -> Array[Vector2]:
	return grave_positions.duplicate()
