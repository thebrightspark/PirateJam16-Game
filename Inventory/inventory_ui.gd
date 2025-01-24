extends Control

@export var inventory: Inventory
@onready var slots: Array = $InvSlots/GridContainer.get_children()

var hovered_slot: InventorySlot = null
var selected_slot: InventorySlot = null

func _ready() -> void:
	for slot: Control in slots:
		slot.mouse_entered.connect(func(): on_slot_mouse_entered(slot))
		slot.mouse_exited.connect(func(): on_slot_mouse_exited(slot))
	update_slots()
	inventory.inventory_changed.connect(update_slots)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		visible = not visible
		get_tree().paused = visible

	if visible and hovered_slot != null and Input.is_action_just_pressed("Click"):
		set_selected_slot(hovered_slot)

func on_slot_mouse_entered(slot: InventorySlot) -> void:
	hovered_slot = slot

func on_slot_mouse_exited(slot: InventorySlot) -> void:
	if hovered_slot == slot:
		hovered_slot = null

func update_slots() -> void:
	for i in range(inventory.modifiers.size()):
		(slots[i] as InventorySlot).set_modifier(inventory.modifiers[i])

func set_selected_slot(slot: InventorySlot) -> void:
	if selected_slot == slot:
		selected_slot.set_selected(false)
		selected_slot = null
	else:
		if selected_slot != null:
			selected_slot.set_selected(false)
		selected_slot = slot
		slot.set_selected(true)
