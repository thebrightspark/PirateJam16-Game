extends Resource
class_name Inventory

signal inventory_added(modifier: BaseModifier)
signal inventory_removed(modifier: BaseModifier)

@export var max_size: int = 20
@export var modifiers: Array[BaseModifier]

func get_modifier(index: int) -> BaseModifier:
	return modifiers[index] if index >= 0 and index < modifiers.size() else null

func find_modifier(modifier: BaseModifier) -> int:
	for i in range(modifiers.size()):
		if modifiers[i] == modifier:
			return i
	return -1

func add_modifier(modifier: BaseModifier) -> bool:
	if modifiers.size() < max_size:
		modifiers.append(modifier)
		inventory_added.emit(modifier)
		return true
	return false

func remove_modifier(modifier: BaseModifier) -> bool:
	var i = find_modifier(modifier)
	if i < 0:
		return false
	modifiers.remove_at(i)
	inventory_removed.emit(modifier)
	return true
