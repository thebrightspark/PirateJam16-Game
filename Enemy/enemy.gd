extends CharacterBody2D

@export var health = 10.0
@export var max_health = 10.0

@onready var health_label: Label = $HealthLabel

func _physics_process(delta: float) -> void:
	health_label.text = str(health)

	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func on_damage(damage: float) -> void:
	health -= damage
	if health <= 0.0:
		queue_free()
