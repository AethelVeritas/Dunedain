extends Area2D

@export var speed: float = 800.0
@export var damage: int = 1
@export var lifetime: float = 3.0

var direction: Vector2 = Vector2.RIGHT

func _ready():
	# Set up collision detection
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	# Auto-destroy after lifetime
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(queue_free)
	add_child(timer)
	timer.start()

func _physics_process(delta):
	# Move the bullet in the direction it's facing
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("Player"):
		# Deal damage to player
		if body.has_method("take_damage"):
			body.take_damage(damage)
		print("Player hit! Damage: ", damage)
		queue_free()
	elif body.is_in_group("Wall") or body.is_in_group("Obstacle"):
		# Hit a wall or obstacle
		queue_free()

func _on_area_entered(area):
	# Handle area collisions if needed
	pass
