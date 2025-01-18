extends CanvasLayer

@export var player: CharacterBody2D
@export_group("Internal")
@export var health_gradient: GradientTexture1D

var health_label: Label
var health_bar: ColorRect

var last_health = 0

func _ready() -> void:
	health_label = get_node("HealthValueLabel")
	health_bar = get_node("HealthBar")

func _process(_delta: float) -> void:
	update_health()

func update_health() -> void:
	var health = player.HEALTH
	if health == last_health:
		return
	last_health = health
	var healthPercentage: float = float(health) / float(player.MAX_HEALTH)
	print("health: ", healthPercentage)
	
	if health_label.visible:
		health_label.text = str(health)
		health_label.label_settings.font_color = get_health_color(healthPercentage)
	
	if health_bar.visible:
		(health_bar.material as ShaderMaterial).set_shader_parameter("percentage", healthPercentage)

func get_health_color(healthPercentage) -> Color:
	var width = health_gradient.get_width() - 1
	var pos = width * healthPercentage
	return health_gradient.get_image().get_pixel(pos, 0)
