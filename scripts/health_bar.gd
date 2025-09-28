extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

@export var bar_width: float = 40.0
@export var bar_height: float = 6.0

func _ready():
	custom_minimum_size = Vector2(bar_width, bar_height)
	progress_bar.custom_minimum_size = Vector2(bar_width, bar_height)

func update_health(current: int, max_health: int):
	progress_bar.max_value = max_health
	progress_bar.value = current
	
	# Change color based on health percentage
	var health_percent = float(current) / float(max_health)
	if health_percent > 0.6:
		progress_bar.get_theme_stylebox("fill").bg_color = Color(0.2, 0.8, 0.2, 1.0)  # Green
	elif health_percent > 0.3:
		progress_bar.get_theme_stylebox("fill").bg_color = Color(0.8, 0.8, 0.2, 1.0)  # Yellow
	else:
		progress_bar.get_theme_stylebox("fill").bg_color = Color(0.8, 0.2, 0.2, 1.0)  # Red