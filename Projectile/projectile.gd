extends RigidBody2D

@export var damage = 2
@export var lifetime = 5
@export var speed = 200
@export var drag = 1.0 # FIXME: Can't get forces to apply :(
@export var gravity = 0.0
@export var bounce = 0
@export var pierce = 0
@export var homing = false
@export var homing_range = 20

const COLLISION_LAYER_ENVIRONMENT = 2
const COLLISION_LAYER_ENEMY = 5
var projectile: PackedScene = preload("res://Projectile/projectile.tscn")

var age: float = 0
var bounces = 0
var pierced = 0

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

func _on_environment_entered(body: Node) -> void:
	handle_bounce(body)

func _on_enemy_entered(body: Node2D) -> void:
	handle_enemy_hit(body)

func _on_enemy_exited(body: Node2D) -> void:
	remove_collision_exception_with(body)

func is_in_collision_layer(body: Node, layer: int) -> bool:
	return body is CollisionObject2D and (body as CollisionObject2D).get_collision_layer_value(layer)

func handle_age(delta: float) -> void:
	age += 1.0 * delta
	if age >= lifetime:
		queue_free()

func handle_enemy_hit(body: Node) -> void:
	if is_in_collision_layer(body, COLLISION_LAYER_ENEMY) && body.has_method("on_damage"):
		body.on_damage(damage)
		pierced += 1
		if pierced > pierce:
			queue_free()
		else:
			add_collision_exception_with(body)

func handle_bounce(body: Node) -> void:
	if is_in_collision_layer(body, COLLISION_LAYER_ENVIRONMENT):
		bounces += 1
		if bounces > bounce:
			queue_free()
