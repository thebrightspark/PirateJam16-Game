extends RigidBody2D

@export var lifetime = 5
@export var speed = 200
@export var drag = 5
@export var bounce = 0
@export var pierce = 0
@export var homing = false
@export var homing_range = 20

var age: float = 0
var velocity = Vector2(0, -speed)

func _ready() -> void:
	self.apply_central_impulse(velocity.rotated(global_rotation).rotated(deg_to_rad(90)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	age += 1.0 * delta
	if age >= lifetime:
		queue_free()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	pass
