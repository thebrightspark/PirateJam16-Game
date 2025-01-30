extends PopupPanel
class_name Tooltip

@export var offset_position: Vector2 = Vector2(0, 0)

@onready var text_container: VBoxContainer = $TextContainer

func set_labels(labels: Array) -> void:
	for child in text_container.get_children():
		child.queue_free()
	if labels == null or labels.is_empty():
		return

	for label in labels:
		text_container.add_child(label.duplicate())
