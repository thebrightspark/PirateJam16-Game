extends RigidBody2D

@export var lifetime = 5
@export var speed = 200
@export var drag = 1.0 # FIXME: Can't get forces to apply :(
@export var gravity = 0.0
@export var bounce = 0
@export var pierce = 0
@export var homing = false
@export var homing_range = 20

const COLLISION_LAYER_ENVIRONMENT = 2
var projectile: PackedScene = preload("res://Projectile/projectile.tscn")

var age: float = 0
var bounces = 0

func _ready() -> void:
	apply_central_impulse(Vector2(0, -speed).rotated(global_rotation).rotated(deg_to_rad(90)))

func _process(delta: float) -> void:
	handle_age(delta)

func _physics_process(_delta: float) -> void:
	look_at(global_position + linear_velocity)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if drag > 0.0:
		var drag_force = -state.linear_velocity.normalized() * drag
		state.apply_central_force(drag_force)
	if gravity > 0.0:
		state.apply_central_force(get_gravity() * gravity)

func _on_body_entered(body: Node) -> void:
	handle_bounce(body)

func handle_age(delta: float) -> void:
	age += 1.0 * delta
	if age >= lifetime:
		queue_free()

func handle_bounce(body: Node) -> void:
	if body is CollisionObject2D and (body as CollisionObject2D).collision_layer == COLLISION_LAYER_ENVIRONMENT:
		bounces += 1
		if bounces > bounce:
			queue_free()
