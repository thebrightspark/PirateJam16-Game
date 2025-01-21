extends Control

@export var inventory: Inventory
@onready var slots: Array = $InvSlots/GridContainer.get_children()

func _ready() -> void:
	update_slots()
	inventory.inventory_changed.connect(update_slots)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		visible = not visible

func update_slots() -> void:
	for i in range(inventory.modifiers.size()):
		(slots[i] as InventorySlot).set_modifier(inventory.modifiers[i])
