extends CharacterBody2D

@export var speed = 200
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
	
	# Only update state if not shooting
	if player_state != "shooting":
		if direction == Vector2.ZERO:
			player_state = "idle"
		else:
			player_state = "walking"
		
		velocity = direction * speed
		move_and_slide()
		
		# Play idle/walk animation
		play_anim(direction)
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	var mouse_loc_from_player = mouse_pos - global_position

	# Shooting logic
	if Input.is_action_just_pressed("left_mouse") and bow_reload and arrow_count > 0:
		bow_reload = false
		player_state = "shooting"
		play_shoot_anim(mouse_loc_from_player)

		# Wait for animation timing
		await get_tree().create_timer(0.4).timeout  # <-- full shoot anim duration

		# Spawn arrow mid-animation (adjust timing if needed)
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		arrow_count -= 1
		print("Arrows remaining: ", arrow_count)

		# Resume movement state + animations
		if direction == Vector2.ZERO:
			player_state = "idle"
		else:
			player_state = "walking"
		play_anim(direction)

		# Reload bow
		await get_tree().create_timer(0.4).timeout
		bow_reload = true
	elif Input.is_action_just_pressed("left_mouse") and arrow_count <= 0:
		print("Out of arrows!") # Feedback


func play_shoot_anim(mouse_loc_from_player):
	if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y < 0:
		$AnimatedSprite2D.play("n-shoot")
	elif mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0:
		$AnimatedSprite2D.play("e-shoot")
	elif mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0:
		$AnimatedSprite2D.play("s-shoot")
	elif mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x < 0:
		$AnimatedSprite2D.play("w-shoot")
	elif mouse_loc_from_player.x > 25 and mouse_loc_from_player.y <= -25:
		$AnimatedSprite2D.play("ne-shoot")
	elif mouse_loc_from_player.x > 0.5 and mouse_loc_from_player.y >= 25:
		$AnimatedSprite2D.play("se-shoot")
	elif mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
		$AnimatedSprite2D.play("sw-shoot")
	elif mouse_loc_from_player.x < -25 and mouse_loc_from_player.y <= -25:
		$AnimatedSprite2D.play("nw-shoot")

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
