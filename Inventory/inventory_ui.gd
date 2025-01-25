extends Control

@export var inventory: Inventory
@onready var inv_slots: Array = $InvSlots/GridContainer.get_children()
@export var equipped_modifiers: ModifierCollection
@onready var equip_slots: Array = $EquipSlots/GridContainer.get_children()

var hovered_slot: InventorySlot = null
var selected_inv_slot: InventorySlot = null
var selected_equip_slot: InventorySlot = null

func _ready() -> void:
	for slot: Control in inv_slots:
		slot.mouse_entered.connect(func(): on_slot_mouse_entered(slot))
		slot.mouse_exited.connect(func(): on_slot_mouse_exited(slot))
	for slot: Control in equip_slots:
		slot.mouse_entered.connect(func(): on_slot_mouse_entered(slot))
		slot.mouse_exited.connect(func(): on_slot_mouse_exited(slot))
	update_inv_slots()
	inventory.inventory_changed.connect(update_inv_slots)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		visible = not visible
		get_tree().paused = visible

	if visible and hovered_slot != null and Input.is_action_just_pressed("Click"):
		handle_slot_click(hovered_slot)

func on_slot_mouse_entered(slot: InventorySlot) -> void:
	hovered_slot = slot

func on_slot_mouse_exited(slot: InventorySlot) -> void:
	if hovered_slot == slot:
		hovered_slot = null

func update_inv_slots() -> void:
	for i in range(inv_slots.size()):
		(inv_slots[i] as InventorySlot).set_modifier(inventory.get_modifier(i))

func update_equip_slots() -> void:
	for i in range(equip_slots.size()):
		(equip_slots[i] as InventorySlot).set_modifier(equipped_modifiers.get_modifier(i))

func handle_slot_click(slot: InventorySlot) -> void:
	if selected_inv_slot == slot:
		# If clicked on selected inv slot, then deselect it
		selected_inv_slot.set_selected(false)
		selected_inv_slot = null
	elif selected_equip_slot == slot:
		# If clicked on selected equip slot, then deselect it
		selected_equip_slot.set_selected(false)
		selected_equip_slot = null
	else:
		if inv_slots.has(slot):
			if selected_equip_slot != null:
				# If clicked on inv slot and already selected equip slot, then swap modifiers
				if swap_slot_contents(slot, selected_equip_slot):
					selected_equip_slot.set_selected(false)
					selected_equip_slot = null
			else:
				# Else change selected inv slot
				if selected_inv_slot != null:
					selected_inv_slot.set_selected(false)
				selected_inv_slot = slot
				slot.set_selected(true)
		elif equip_slots.has(slot):
			if selected_inv_slot != null:
				# If clicked on equip slot and already selected inv slot, then swap modifiers
				if swap_slot_contents(selected_inv_slot, slot):
					selected_inv_slot.set_selected(false)
					selected_inv_slot = null
			else:
				# Else change selected equip slot
				if selected_equip_slot != null:
					selected_equip_slot.set_selected(false)
				selected_equip_slot = slot
				slot.set_selected(true)

func swap_slot_contents(inv_slot: InventorySlot, equip_slot: InventorySlot) -> bool:
	if inv_slot.contained_modifier == null and equip_slot.contained_modifier == null:
		return false
	# TODO: Check bandwidth!
	var inv_i = inv_slots.find(inv_slot)
	var equip_i = equip_slots.find(equip_slot)
	var inv_mod = inv_slot.contained_modifier
	var equip_mod = equip_slot.contained_modifier
	if inv_mod != null:
		inventory.remove_modifier(inv_i)
		equipped_modifiers.add_modifier(inv_mod)
	if equip_mod != null:
		equipped_modifiers.remove_modifier(equip_i)
		inventory.add_modifier(equip_mod)
	update_equip_slots()
	return true
