extends CharacterBody2D

@export var speed = 400
@export var max_health: int = 100
var current_health: int = max_health

const GRAVE = preload("res://scenes/grave.tscn")

var player_state 

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y == 0:
		
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
		
	velocity = direction * speed
	move_and_slide()

	#play_anim(direction)

func take_damage(amount: int):
	current_health -= amount
	print("Player health: ", current_health, "/", max_health)
	
	if current_health <= 0:
		die()

func die():
	print("Player died!")
	
	# Spawn grave at player's position
	var grave = GRAVE.instantiate()
	get_parent().add_child(grave)
	grave.global_position = global_position
	
	# Small delay before restarting scene
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()