extends Panel
class_name InventorySlot

@export var contained_modifier: BaseModifier

@onready var content_display: Sprite2D = $Control/CenterContainer/Panel/ContentDisplay
@onready var unselected_border: Control = $Control/Unselected
@onready var selected_border: Control = $Control/Selected

static var tooltip_label_settings: LabelSettings = preload("res://Overlay/tooltip_label_settings.tres")
static var chip_scene: PackedScene = preload("res://Overlay/chip.tscn")
static var tooltip_chip_container: PackedScene = preload("res://Overlay/tooltip_chip_container.tscn")

var is_selected: bool = false
var tooltip: Array = []

func _ready() -> void:
	if contained_modifier != null:
		content_display.texture = contained_modifier.texture
		set_tooltip(contained_modifier)
	set_selected(false)

func set_modifier(modifier: BaseModifier) -> void:
	contained_modifier = modifier
	content_display.texture = modifier.texture if modifier != null else null
	set_tooltip(modifier)

func set_selected(selected: bool) -> void:
	is_selected = selected
	unselected_border.visible = not selected
	selected_border.visible = selected

func set_tooltip(modifier: BaseModifier) -> void:
	if modifier == null:
		tooltip = []
		return

	var types = []
	for t in modifier.type:
		types.append(create_tooltip_chip(t.name, t.color))

	tooltip = [
		create_tooltip_label(modifier.name),
		create_tooltip_label(modifier.tier.name, modifier.tier.color),
		#create_tooltip_label(types)
		create_hbox(types)
	]

func create_tooltip_label(label_text: String, color: Color = tooltip_label_settings.font_color) -> Label:
	var label = Label.new()
	label.text = label_text
	label.label_settings = tooltip_label_settings.duplicate()
	label.label_settings.font_color = color
	return label

func create_tooltip_chip(chip_text: String, color: Color) -> Chip:
	var chip = chip_scene.instantiate()
	chip.set_content(chip_text, color)
	return chip

func create_hbox(children: Array) -> HBoxContainer:
	var box = tooltip_chip_container.instantiate()
	for c in children:
		box.add_child(c)
	#box.queue_redraw()
	return box
