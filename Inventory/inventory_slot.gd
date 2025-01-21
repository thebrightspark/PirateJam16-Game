extends Panel
class_name InventorySlot

@export var contained_modifier: BaseModifier
@onready var content_display: Sprite2D = $Control/CenterContainer/Panel/ContentDisplay

func _ready() -> void:
	if contained_modifier != null:
		content_display.texture = contained_modifier.texture

func set_modifier(modifier: BaseModifier) -> void:
	contained_modifier = modifier
	content_display.texture = modifier.texture if modifier != null else null
