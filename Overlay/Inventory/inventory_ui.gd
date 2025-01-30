extends Control

@export var player_data: PlayerData

@onready var left_equip_slots: VBoxContainer = %LeftEquipSlotsWrapper
@onready var right_equip_slots: VBoxContainer = %RightEquipSlotsWrapper
@onready var inv_slots: VBoxContainer = %InvSlotsWrapper
#@onready var tooltip: Tooltip = $Tooltip

static var equip_slot_scene: PackedScene = preload("res://Overlay/Inventory/Slot/equip_slot.tscn")
static var inv_slot_scene: PackedScene = preload("res://Overlay/Inventory/Slot/inv_slot.tscn")

#var hovered_slot: InventorySlot = null

func _ready() -> void:
	player_data.inventory.inventory_added.connect(add_inv_modifier_slot)

	for modifier in player_data.modifiers_left.modifiers:
		add_left_modifier_slot(modifier)
	for modifier in player_data.modifiers_right.modifiers:
		add_right_modifier_slot(modifier)
	for modifier in player_data.inventory.modifiers:
		add_inv_modifier_slot(modifier)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		visible = not visible
		get_tree().paused = visible

	#render_tooltip()

func on_left_modifier_removed(slot: EquipSlot) -> void:
	if player_data.modifiers_left.remove_modifier(slot.contained_modifier):
		player_data.inventory.add_modifier(slot.contained_modifier)
	slot.queue_free()

func on_right_modifier_removed(slot: EquipSlot) -> void:
	if player_data.modifiers_right.remove_modifier(slot.contained_modifier):
		player_data.inventory.add_modifier(slot.contained_modifier)
	slot.queue_free()

func on_left_modifier_added(slot: InvSlot) -> void:
	if player_data.inventory.remove_modifier(slot.contained_modifier):
		player_data.modifiers_left.add_modifier(slot.contained_modifier)
		add_left_modifier_slot(slot.contained_modifier)
	slot.queue_free()

func on_right_modifier_added(slot: InvSlot) -> void:
	if player_data.inventory.remove_modifier(slot.contained_modifier):
		player_data.modifiers_right.add_modifier(slot.contained_modifier)
		add_right_modifier_slot(slot.contained_modifier)
	slot.queue_free()

func add_left_modifier_slot(modifier: BaseModifier) -> void:
	var slot: EquipSlot = equip_slot_scene.instantiate()
	slot.set_modifier(modifier)
	left_equip_slots.add_child(slot)
	slot.add_remove_listener(func(): on_left_modifier_removed(slot))

func add_right_modifier_slot(modifier: BaseModifier) -> void:
	var slot: EquipSlot = equip_slot_scene.instantiate()
	slot.set_modifier(modifier)
	right_equip_slots.add_child(slot)
	slot.add_remove_listener(func(): on_right_modifier_removed(slot))

func add_inv_modifier_slot(modifier: BaseModifier) -> void:
	var slot: InvSlot = inv_slot_scene.instantiate()
	slot.set_modifier(modifier)
	inv_slots.add_child(slot)
	slot.add_left_listener(func(): on_left_modifier_added(slot))
	slot.add_right_listener(func(): on_right_modifier_added(slot))

#func render_tooltip() -> void:
	#if visible:
		#tooltip.visible = hovered_slot != null && hovered_slot.contained_modifier != null
		#if tooltip.visible:
			#tooltip.position = get_global_mouse_position() + tooltip.offset_position
