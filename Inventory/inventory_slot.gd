extends Panel
class_name InventorySlot

@export var contained_modifier: BaseModifier

@onready var content_display: Sprite2D = $Control/CenterContainer/Panel/ContentDisplay
@onready var unselected_border: Control = $Control/Unselected
@onready var selected_border: Control = $Control/Selected

var is_selected: bool = false

func _ready() -> void:
	if contained_modifier != null:
		content_display.texture = contained_modifier.texture
		tooltip_text = contained_modifier.name
	set_selected(false)

func set_modifier(modifier: BaseModifier) -> void:
	contained_modifier = modifier
	content_display.texture = modifier.texture if modifier != null else null
	tooltip_text = modifier.name

func set_selected(selected: bool) -> void:
	is_selected = selected
	unselected_border.visible = not selected
	selected_border.visible = selected
