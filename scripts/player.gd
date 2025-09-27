extends CharacterBody2D

@export var speed = 400
@export var max_arrows = 10 # Maximum arrows the player can carry
var max_health = 100
var current_health: int = max_health
var arrow_count: int = max_arrows # Current arrow count

const GRAVE = preload("res://scenes/grave.tscn")

var player_state
#var bow_equiped = true
var bow_reload = true
var arrow = preload("res://scenes/arrow.tscn")

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
		
	velocity = direction * speed
	move_and_slide()
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("left_mouse") and bow_reload:
		if arrow_count > 0:
			#bow_equiped = false
			var arrow_instance = arrow.instantiate()
			arrow_instance.rotation = $Marker2D.rotation
			arrow_instance.global_position = $Marker2D.global_position
			add_child(arrow_instance)
			arrow_count -= 1 # Consume an arrow
			print("Arrows remaining: ", arrow_count)
			await get_tree().create_timer(0.4).timeout
			bow_reload = true
		else:
			print("Out of arrows!") # Feedback when no arrows available
 	
	#play_anim(direction)

func take_damage(amount: int):
	current_health -= amount
	print("Player health: ", current_health, "/", max_health)
	
	if current_health <= 0:
		die()

func die():
	print("Player died!")

	# Save grave position to game manager
	GameManager.add_grave_position(global_position)

	# Small delay before restarting scene
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()

func _ready():
	# Reset stats when player spawns
	current_health = max_health
	arrow_count = max_arrows


func add_arrows(amount: int):
	arrow_count += amount		
	print("Arrows remaining: ", arrow_count)
