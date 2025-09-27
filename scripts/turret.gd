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
		if ray_cast.is_colliding() and ray_cast.get_collider().is_in_group("Player"):
			gun_sprite.rotation = angle_to_target
			if reload_timer.is_stopped():
				shoot()

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
