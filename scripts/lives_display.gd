extends Control

@onready var label: Label = $Label

func _ready():
	update_lives(GameManager.get_player_lives())

func update_lives(current_lives: int):
	if label:
		var hearts_text = ""
		for i in range(current_lives):
			hearts_text += "♥ "
		label.text = hearts_text

		# Optional: Change color based on lives remaining
		if current_lives > 2:
			label.modulate = Color(1, 0.2, 0.2, 1) # Bright red
		elif current_lives > 1:
			label.modulate = Color(1, 0.5, 0.2, 1) # Orange
		else:
			label.modulate = Color(0.8, 0.8, 0.8, 1) # Gray/white
