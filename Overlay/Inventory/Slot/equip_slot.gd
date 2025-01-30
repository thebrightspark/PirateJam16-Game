extends Panel
class_name EquipSlot

@export var contained_modifier: BaseModifier

@onready var modifier_sprite: ModifierSprite = %ModifierSprite
@onready var name_label: Label = %NameLabel
@onready var tier_label: Label = %TierLabel
@onready var type_box: HBoxContainer = %TypeHBox
@onready var remove_button: Button = %RemoveButton

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

func add_remove_listener(callable: Callable) -> void:
	remove_button.pressed.connect(callable)

func set_modifier(modifier: BaseModifier) -> void:
	contained_modifier = modifier

func create_chip(chip_text: String, color: Color) -> Chip:
	var chip = chip_scene.instantiate()
	chip.set_content(chip_text, color)
	return chip
