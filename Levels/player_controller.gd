extends CharacterBody2D

@export var SPEED = 150.0
@export var JUMP_VELOCITY = -400.0

func _init() -> void:
	floor_max_angle = deg_to_rad(0)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("Left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("Right"):
		velocity.x = SPEED
	else:
		velocity.x = 0

	move_and_slide()
