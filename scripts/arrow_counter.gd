extends Control

@onready var label: Label = $Label

@export var max_arrows: int = 100

func _ready():
    update_arrows(max_arrows)

func update_arrows(current_arrows: int):
    if label:
        label.text = "Arrows: " + str(current_arrows) + "/" + str(max_arrows)

        # Optional: Change color based on arrow count
        var arrow_percent = float(current_arrows) / float(max_arrows)
        if arrow_percent > 0.5:
            label.modulate = Color(1, 1, 1, 1) # White
        elif arrow_percent > 0.25:
            label.modulate = Color(1, 1, 0.5, 1) # Yellow
        else:
            label.modulate = Color(1, 0.5, 0.5, 1) # Red
