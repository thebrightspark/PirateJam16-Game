extends CharacterBody2D

@export var health = 10.0
@export var max_health = 10.0

var health_label: Label

func _ready() -> void:
	health_label = get_node("HealthLabel")

func _physics_process(delta: float) -> void:
	health_label.text = str(health)

	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func on_damage(damage: float) -> void:
	health -= damage
	if health <= 0.0:
		queue_free()
