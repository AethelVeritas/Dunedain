extends Node2D

const GRAVE = preload("res://scenes/grave.tscn")

func _ready():
	# Respawn all graves from the game manager
	var grave_positions = GameManager.get_grave_positions()
	for pos in grave_positions:
		var grave = GRAVE.instantiate()
		add_child(grave)
		grave.global_position = pos
