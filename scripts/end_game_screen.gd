extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var graves_label = $Panel/VBoxContainer/GravesLabel
@onready var lives_used_label = $Panel/VBoxContainer/LivesUsedLabel

func _ready():
	# Set up the screen
	$Panel.visible = true
	animation_player.play("fade_in")

func show_end_screen(graves_count: int, lives_lost: int):
	# Update stats
	graves_label.text = "Lives Sacrificed: " + str(graves_count)
	#lives_used_label.text = "Lives Lost: " + str(lives_lost)
	
	# Show the screen
	visible = true
	animation_player.play("fade_in")

func _on_restart_button_pressed():
	# Unpause the game before transitioning
	get_tree().paused = false

	# Reset all game state
	GameManager.reset_lives()
	GameManager.clear_graves()
	GameManager.clear_arrow_pickups()
	GameManager.clear_defeated_turrets()

	# Restart the game by going back to introduction
	get_tree().change_scene_to_file("res://scenes/introduction.tscn")

func show_level_complete():
	# Update the title and labels for level completion
	$Panel/VBoxContainer/TitleLabel.text = "LEVEL COMPLETE!"
	$Panel/VBoxContainer/StatsLabel.text = "You've survived level one"
	$Panel/VBoxContainer/GravesLabel.text = "more to come..."
	$Panel/VBoxContainer/LivesUsedLabel.text = ""
	$Panel/VBoxContainer/ButtonsContainer/RestartButton.text = "Restart"
	$Panel/VBoxContainer/ButtonsContainer/QuitButton.text = "Quit"

	# Show the screen
	visible = true
	animation_player.play("fade_in")

func _on_quit_button_pressed():
	# Unpause the game before quitting
	get_tree().paused = false

	# Quit the game
	get_tree().quit()
