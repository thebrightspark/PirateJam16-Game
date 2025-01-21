extends CanvasLayer

@export var player: CharacterBody2D
@export_group("Internal")
@export var health_gradient: GradientTexture1D

@onready var health_label: Label = $HealthValueLabel
@onready var health_bar: ColorRect = $HealthBar
@onready var velocity_label: Label = $VelValueLabel

var last_health = 0

func _process(_delta: float) -> void:
	update_health()
	update_veloctiy()

func update_health() -> void:
	var health = player.health
	if health == last_health:
		return
	last_health = health
	var healthPercentage: float = float(health) / float(player.max_health)
	
	if health_label.visible:
		health_label.text = str(health)
		health_label.label_settings.font_color = get_health_color(healthPercentage)
	
	if health_bar.visible:
		(health_bar.material as ShaderMaterial).set_shader_parameter("percentage", healthPercentage)

func update_veloctiy() -> void:
	if velocity_label.visible:
		velocity_label.text = str(player.velocity.y)

func get_health_color(healthPercentage) -> Color:
	var width = health_gradient.get_width() - 1
	var pos = width * healthPercentage
	return health_gradient.get_image().get_pixel(pos, 0)
