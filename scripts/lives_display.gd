extends Control

@onready var label: Label = $Label
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

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
	if animated_sprite_2d:
		var animation_name = str(current_lives)
		if animated_sprite_2d.sprite_frames.has_animation(animation_name):
			animated_sprite_2d.play(animation_name)
