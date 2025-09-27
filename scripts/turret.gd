extends Node2D

@export var BULLET: PackedScene = preload("res://scenes/bullet.tscn")

var target: Node2D = null
@onready var reload_timer: Timer = $ReloadTimer
@onready var ray_cast: RayCast2D = $"."
@onready var gun_sprite: Sprite2D = $"../Sprite2D"

#const player = preload("uid://bh1w0ho7ry2kq")
func _ready():
	await get_tree().process_frame
	target = find_target()

func _physics_process(delta):
	if target != null:
		var angle_to_target = global_position.angle_to_point(target.global_position)
		ray_cast.look_at(target.global_position)
		
		# Check if any part of the player is visible
		if has_line_of_sight_to_player():
			gun_sprite.rotation = angle_to_target
			if reload_timer.is_stopped():
				shoot()

func has_line_of_sight_to_player() -> bool:
	# Get the player's collision shape
	var player_collision = target.get_node("CollisionShape2D")
	if player_collision == null or player_collision.shape == null:
		return false
	
	# Get the collision rectangle extents (half size)
	var shape_size = player_collision.shape.size
	var extents = shape_size / 2.0
	
	# Get the collision shape's position relative to player
	var collision_offset = player_collision.position
	
	# Define the four corners of the player's collision rectangle
	var corners = [
		target.global_position + collision_offset + Vector2(-extents.x, -extents.y),  # Top-left
		target.global_position + collision_offset + Vector2(extents.x, -extents.y),   # Top-right
		target.global_position + collision_offset + Vector2(-extents.x, extents.y),   # Bottom-left
		target.global_position + collision_offset + Vector2(extents.x, extents.y)     # Bottom-right
	]
	
	# Check ray cast to each corner
	for corner in corners:
		ray_cast.look_at(corner)
		ray_cast.force_raycast_update()
		if ray_cast.is_colliding() and ray_cast.get_collider().is_in_group("Player"):
			return true
	
	# Also check the center for good measure
	ray_cast.look_at(target.global_position)
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding() and ray_cast.get_collider().is_in_group("Player"):
		return true
	
	return false

func shoot():
	print("PEW")
	ray_cast.enabled = false
	
	if BULLET:
		var bullet: Area2D = BULLET.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = ray_cast.global_rotation
		# Set the bullet's direction to match the turret's rotation
		bullet.direction = Vector2.RIGHT.rotated(ray_cast.global_rotation)
	
	reload_timer.start()
#
func find_target():
	var new_target: Node2D = null
	
	var player = get_tree().get_first_node_in_group("Player")
	print(player)
	if player != null:
		new_target = player
	
	return new_target


func _on_reload_timer_timeout() -> void:
	print("reload timeout")
	reload_timer.stop()
	ray_cast.enabled = true
