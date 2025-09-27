extends CharacterBody2D

@export var speed = 400
@export var max_health: int = 1000
@export var max_arrows = 100 # Maximum arrows the player can carry
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
	
	play_anim(direction)

func play_anim(dir: Vector2):
	# GPT-generated, so you don't have to type out the whole "$AnimatedSprite2D.play("n-walk") for example
	if player_state == "idle":
		$AnimatedSprite2D.play("idle")
	elif player_state == "walking":
		var d = Vector2(round(dir.x), round(dir.y))
		var anim_name = ""

		if d.y == -1:
			anim_name += "n"
		elif d.y == 1:
			anim_name += "s"
		
		if d.x == -1:
			anim_name += "w"
		elif d.x == 1:
			anim_name += "e"
		
		if anim_name != "":
			anim_name += "-walk"
			$AnimatedSprite2D.play(anim_name)

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