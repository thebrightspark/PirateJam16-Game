extends Control

@onready var label: Label = $HoverLabel

func set_text(text: String) -> void:
	label.text = text
	self.size.x = label.size.x + (label.offset_left * 2)
