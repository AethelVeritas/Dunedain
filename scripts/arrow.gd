extends Area2D

var speed = 500

func _ready() -> void:
	set_as_top_level(true)
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += (Vector2.RIGHT*speed).rotated(rotation) * delta
	
	


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	# Check if the body is a StaticBody2D (which graves are)
	if body is StaticBody2D:
		queue_free()
