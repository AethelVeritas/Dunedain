extends Node2D

const GRAVE = preload("res://scenes/grave.tscn")
const ARROW_PICKUP = preload("res://scenes/arrow_pickup.tscn")
const TURRET = preload("res://scenes/turret.tscn")
const END_GAME_SCREEN = preload("res://scenes/end_game_screen.tscn")

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

	# Connect end screen area signal
	$EndScreenArea.body_entered.connect(_on_end_screen_area_body_entered)

func _on_end_screen_area_body_entered(body):
	if body.name == "Player":
		show_level_complete_screen()

func show_level_complete_screen():
	# Pause the game to prevent player death during level complete
	get_tree().paused = true

	var end_screen = END_GAME_SCREEN.instantiate()
	add_child(end_screen)
	end_screen.show_level_complete()
