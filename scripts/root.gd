extends Node2D

const GRAVE = preload("res://scenes/grave.tscn")
const ARROW_PICKUP = preload("res://scenes/arrow_pickup.tscn")
const TURRET = preload("res://scenes/turret.tscn")

func _ready():
	# Reset lives for new game (only if it's actually a new game, not a respawn)
	if GameManager.is_game_over():
		GameManager.reset_lives()

	# Respawn all graves from the game manager
	var grave_positions = GameManager.get_grave_positions()
	for pos in grave_positions:
		var grave = GRAVE.instantiate()
		add_child(grave)
		grave.global_position = pos

	# Respawn all arrow pickups from the game manager
	var arrow_pickup_positions = GameManager.get_arrow_pickup_positions()
	for pos in arrow_pickup_positions:
		var arrow_pickup = ARROW_PICKUP.instantiate()
		add_child(arrow_pickup)
		arrow_pickup.global_position = pos
