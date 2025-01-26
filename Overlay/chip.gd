extends Control
class_name Chip

@onready var background: ChipBackground = $Background
@onready var label: Label = $ChipText

@export var chip_text: String
@export var chip_color: Color

func set_content(text: String, color: Color) -> void:
	chip_text = text
	chip_color = color

func _ready() -> void:
	label.text = chip_text
	background.color = chip_color
	var text_width = Util.get_label_text_size(label).x
	background.width = text_width
	background.queue_redraw()
	custom_minimum_size = background.calculate_size()
