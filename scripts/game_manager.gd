extends Node

# Array to store grave positions
var grave_positions: Array[Vector2] = []
# Array to store arrow pickup positions
var arrow_pickup_positions: Array[Vector2] = []
# Array to store defeated turret positions (so they don't respawn)
var defeated_turret_positions: Array[Vector2] = []

const GRAVE = preload("res://scenes/grave.tscn")
const ARROW_PICKUP = preload("res://scenes/arrow_pickup.tscn")

# Add a grave position and instantiate it immediately
func add_grave_position(position: Vector2):
	grave_positions.append(position)

	# Instantiate grave immediately in the current scene
	var current_scene = get_tree().current_scene
	if current_scene:
		var grave = GRAVE.instantiate()
		current_scene.add_child(grave)
		grave.global_position = position

# Add an arrow pickup at the specified position and store it persistently
func add_arrow_pickup(position: Vector2):
	arrow_pickup_positions.append(position)
	
	var current_scene = get_tree().current_scene
	if current_scene:
		var arrow_pickup = ARROW_PICKUP.instantiate()
		current_scene.add_child(arrow_pickup)
		arrow_pickup.global_position = position

# Remove an arrow pickup position when it's collected
func remove_arrow_pickup(position: Vector2):
	arrow_pickup_positions.erase(position)

# Add a defeated turret position (so it won't respawn)
func add_defeated_turret(position: Vector2):
	defeated_turret_positions.append(position)

# Check if a turret position has been defeated
func is_turret_defeated(position: Vector2) -> bool:
	return defeated_turret_positions.has(position)

# Clear all grave positions (for when starting a new game)
func clear_graves():
	grave_positions.clear()

# Clear all arrow pickup positions (for when starting a new game)
func clear_arrow_pickups():
	arrow_pickup_positions.clear()

# Clear all defeated turret positions (for when starting a new game)
func clear_defeated_turrets():
	defeated_turret_positions.clear()

# Get all grave positions
func get_grave_positions() -> Array[Vector2]:
	return grave_positions.duplicate()

# Get all arrow pickup positions
func get_arrow_pickup_positions() -> Array[Vector2]:
	return arrow_pickup_positions.duplicate()
