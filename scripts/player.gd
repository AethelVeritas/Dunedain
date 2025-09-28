extends CharacterBody2D

@export var speed = 200
@export var max_health: int = 100
@export var max_arrows = 10

var current_health: int = max_health
var arrow_count: int = max_arrows # Current arrow count
@onready var health_bar: Control = $AnimatedSprite2D/Camera2D/CanvasLayer/HealthBar
@onready var arrow_counter: Control = $AnimatedSprite2D/Camera2D/CanvasLayer/ArrowCounter
@onready var lives_display: Control = $AnimatedSprite2D/Camera2D/CanvasLayer/LivesDisplay

var player_state
var is_dead: bool = false
var game_over_screen_active: bool = false
#var bow_equiped = true
var bow_reload = true
var arrow = preload("res://scenes/arrow.tscn")

func _physics_process(delta):
	# Block all controls when game over screen is active
	if game_over_screen_active:
		return

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
		await get_tree().create_timer(0.4).timeout # <-- full shoot anim duration

		# Spawn arrow mid-animation (adjust timing if needed)
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		arrow_count -= 1
		print("Arrows remaining: ", arrow_count)
		if arrow_counter:
			arrow_counter.update_arrows(arrow_count)

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
	# Don't take damage if already dead
	if is_dead:
		return

	current_health -= amount
	print("Player health: ", current_health, "/", max_health)

	if health_bar:
		health_bar.update_health(current_health, max_health)

	if current_health <= 0:
		is_dead = true
		$AnimatedSprite2D.play("death")
		die()

func die():
	print("Player died!")

	# Save grave position to game manager
	GameManager.add_grave_position(global_position)

	# Lose a life
	var has_lives_remaining = GameManager.lose_life()

	# Update lives display
	if lives_display:
		lives_display.update_lives(GameManager.get_player_lives())

	if has_lives_remaining:
		# Reset player health and continue
		await get_tree().create_timer(0.5).timeout
		reset_player()
	else:
		# Game over - all lives lost
		await get_tree().create_timer(0.5).timeout
		game_over()

func reset_player():
	# Reset player health and position
	current_health = max_health
	arrow_count = max_arrows
	is_dead = false
	game_over_screen_active = false
	global_position = Vector2(0, 0) # Or whatever the spawn position should be

	# Update UI
	if health_bar:
		health_bar.update_health(current_health, max_health)
	if arrow_counter:
		arrow_counter.update_arrows(arrow_count)
	if lives_display:
		lives_display.update_lives(GameManager.get_player_lives())

	print("Player respawned with", GameManager.get_player_lives(), "lives remaining")

func game_over():
	print("Game Over! No lives remaining.")

	# Block all player controls
	game_over_screen_active = true

	# Show end game screen instead of quitting
	var end_screen = preload("res://scenes/end_game_screen.tscn").instantiate()
	get_tree().current_scene.add_child(end_screen)

	# Calculate stats
	var graves_count = GameManager.get_grave_positions().size()
	var lives_lost = GameManager.MAX_LIVES - GameManager.get_player_lives()

	end_screen.show_end_screen(graves_count, lives_lost)

func _ready():
	# Reset stats when player spawns
	current_health = max_health
	arrow_count = max_arrows
	is_dead = false
	game_over_screen_active = false
	if health_bar:
		health_bar.update_health(current_health, max_health)
	if arrow_counter:
		arrow_counter.update_arrows(arrow_count)
	if lives_display:
		lives_display.update_lives(GameManager.get_player_lives())

func add_arrows(amount: int):
	arrow_count += amount
	print("Arrows remaining: ", arrow_count)
	if arrow_counter:
		arrow_counter.update_arrows(arrow_count)
