extends Sprite2D
class_name ModifierSprite

var shader_material: ShaderMaterial = self.material

func set_colors_from_modifier(modifier: BaseModifier) -> void:
	shader_material.set_shader_parameter("BG_Color", modifier.background_color)
	shader_material.set_shader_parameter("Border_Color", modifier.border_color)
	shader_material.set_shader_parameter("Circuit_Color", modifier.circuit_color)
	shader_material.set_shader_parameter("Chip_Color", modifier.chip_color)
