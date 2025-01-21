extends Resource
class_name Inventory

signal inventory_changed

@export var max_size: int = 20
@export var modifiers: Array[BaseModifier]

func add_modifier(modifier: BaseModifier) -> bool:
	if modifiers.size() < max_size:
		modifiers.append(modifier)
		inventory_changed.emit()
		return true
	return false

func remove_modifier(index: int) -> void:
	if index  >= 0 and index < modifiers.size():
		modifiers.remove_at(index)
		inventory_changed.emit()
