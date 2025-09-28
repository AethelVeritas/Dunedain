extends Control

@onready var label: Label = $Label
@export var max_arrows = 10

func _ready():
	# Get max_arrows from the player instance
	var player = get_parent().get_parent().get_parent().get_parent()
	if player and "max_arrows" in player:
		max_arrows = player.max_arrows
	update_arrows(max_arrows)


func update_arrows(current_arrows: int):
	if label:
		label.text = str(current_arrows)

		# Optional: Change color based on arrow count
		var arrow_percent = float(current_arrows) / float(max_arrows)
		if arrow_percent > 0.5:
			label.modulate = Color(1, 1, 1, 1) # White
		elif arrow_percent > 0.25:
			label.modulate = Color(1, 1, 0.5, 1) # Yellow
		else:
			label.modulate = Color(1, 0.5, 0.5, 1) # Red
