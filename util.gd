extends Node

var collision_layer_map = {}

func _ready() -> void:
	for i in range(1, 33):
		var layer_name = ProjectSettings.get_setting("layer_names/2d_physics/layer_" + str(i))
		collision_layer_map[layer_name] = i
	print("Collision layers: ", collision_layer_map)

func is_in_collision_layer(body: Node, layer: String) -> bool:
	if body is not CollisionObject2D:
		return false
	var layer_id = collision_layer_map[layer]
	return (body as CollisionObject2D).get_collision_layer_value(layer_id)

func get_label_text_size(label: Label) -> Vector2:
	return label.get_theme_font("font").get_string_size(
		label.text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		label.label_settings.font_size
	)
