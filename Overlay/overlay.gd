extends CanvasLayer

@export var player: CharacterBody2D
@export var health_gradient: GradientTexture1D

var health_label: Label

var last_health = 0

func _ready() -> void:
	health_label = get_node("HealthValueLabel")
	pass # Replace with function body.

func _process(delta: float) -> void:
	update_health()

func update_health() -> void:
	var health = player.HEALTH
	if health == last_health:
		return
	last_health = health
	health_label.text = str(health)
	health_label.label_settings.font_color = get_health_color(health, player.MAX_HEALTH)

func get_health_color(health, max_health) -> Color:
	var healthPercentage = health / max_health
	var width = health_gradient.get_width() - 1
	var pos = width * healthPercentage
	return health_gradient.get_image().get_pixel(pos, 0)
