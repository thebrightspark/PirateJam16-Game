extends CharacterBody2D

@export var max_health = 100
@export var health = max_health
@export var speed = 150.0
@export var jump_speed = 400.0
@export var attack_cooldown_millis = 500

var projectile: PackedScene = preload("res://Projectile/projectile.tscn")
var last_attack_timestamp = 0.0

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_attacking()

func handle_movement(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = -jump_speed

	# Handle horizontal movement
	if Input.is_action_pressed("Left"):
		velocity.x = -speed
	elif Input.is_action_pressed("Right"):
		velocity.x = speed
	else:
		velocity.x = 0

	move_and_slide()

func handle_attacking() -> void:
	var time = Time.get_ticks_msec()
	var is_after_cooldown = time > last_attack_timestamp + attack_cooldown_millis
	if is_after_cooldown and Input.is_action_pressed("Click"):
		last_attack_timestamp = time
		var mouse_pos = get_global_mouse_position()
		var look_vec = (mouse_pos - self.global_position).normalized()
		var instance: Node2D = projectile.instantiate()
		instance.global_position = self.global_position + (look_vec * 15)
		instance.look_at(mouse_pos)
		add_sibling(instance)
