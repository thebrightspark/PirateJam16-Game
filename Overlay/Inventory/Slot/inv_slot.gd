extends Panel
class_name InvSlot

@export var contained_modifier: BaseModifier

@onready var modifier_sprite: ModifierSprite = %ModifierSprite
@onready var name_label: Label = %NameLabel
@onready var tier_label: Label = %TierLabel
@onready var type_box: HBoxContainer = %TypeHBox
@onready var left_button: Button = %LeftButton
@onready var right_button: Button = %RightButton

static var chip_scene: PackedScene = preload("res://Overlay/Chip/chip.tscn")

func _ready() -> void:
	if contained_modifier == null:
		return
	modifier_sprite.set_colors_from_modifier(contained_modifier)
	name_label.text = contained_modifier.name
	tier_label.text = contained_modifier.tier.name
	tier_label.label_settings = tier_label.label_settings.duplicate(true)
	tier_label.label_settings.font_color = contained_modifier.tier.color
	for type_chip in type_box.get_children():
		type_chip.queue_free()
	for type in contained_modifier.type:
		type_box.add_child(create_chip(type.name, type.color))

func add_left_listener(callable: Callable) -> void:
	left_button.pressed.connect(callable)

func add_right_listener(callable: Callable) -> void:
	right_button.pressed.connect(callable)
 
func set_modifier(modifier: BaseModifier) -> void:
	contained_modifier = modifier

func create_chip(chip_text: String, color: Color) -> Chip:
	var chip = chip_scene.instantiate()
	chip.set_content(chip_text, color)
	return chip
