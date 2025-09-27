extends Area2D

var arrows_to_give: int = 5

func _ready():
	# Connect to the body_entered signal to detect when player enters
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	# Check if the body that entered is the player
	if body.is_in_group("Player"):
		# Get the player script and add arrows
		var player = body as CharacterBody2D
		if player.has_method("add_arrows"):
			player.add_arrows(arrows_to_give)
			print("Picked up ", arrows_to_give, " arrows!")
			# Remove the pickup area after collecting
			queue_free()
