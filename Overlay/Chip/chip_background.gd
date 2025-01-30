extends Control
class_name ChipBackground

@export var color: Color = Color.WHITE
@export var chip_size: float = 10.0
@export var width_trim: float = 4.0
@export var width: float = 40

func _draw() -> void:
	draw_circle(Vector2(chip_size, chip_size * 1.5), chip_size, color)
	draw_circle(Vector2(chip_size + width - width_trim, chip_size * 1.5), chip_size, color)
	draw_rect(Rect2(chip_size, chip_size / 2.0, width - width_trim, chip_size * 2.0), color)

func calculate_size() -> Vector2:
	var circle_size = chip_size * 2
	return Vector2(width + circle_size, circle_size)
