extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var start_button = $Panel/VBoxContainer/StartButton

func _ready():
	# Set up the screen
	$Panel.visible = true
	animation_player.play("fade_in")

func _on_start_button_pressed():
	# Transition to the introduction level
	get_tree().change_scene_to_file("res://scenes/introduction.tscn")
