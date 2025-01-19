extends RigidBody2D

@export var base_damage: int = 1
@export var attributes: ProjectileAttributes = ProjectileAttributes.new()

const COLLISION_LAYER_ENVIRONMENT = 2
const COLLISION_LAYER_ENEMY = 5
var projectile: PackedScene = preload("res://Projectile/projectile.tscn")

var age: float = 0
var bounces = 0
var pierced = 0

func _ready() -> void:
	apply_central_impulse(Vector2(0, -attributes.speed).rotated(global_rotation).rotated(deg_to_rad(90)))

func _process(delta: float) -> void:
	handle_age(delta)

func _physics_process(_delta: float) -> void:
	look_at(global_position + linear_velocity)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if attributes.drag > 0.0:
		var drag_force = -state.linear_velocity.normalized() * attributes.drag
		state.apply_central_force(drag_force)
	if attributes.gravity > 0.0:
		state.apply_central_force(get_gravity() * attributes.gravity)

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
	if age >= attributes.lifetime:
		queue_free()

func handle_enemy_hit(body: Node2D) -> void:
	if is_in_collision_layer(body, COLLISION_LAYER_ENEMY) && body.has_method("on_damage"):
		body.on_damage(base_damage + attributes.damage)
		pierced += 1
		if pierced > attributes.pierce:
			queue_free()
		else:
			add_collision_exception_with(body)

func handle_bounce(body: Node) -> void:
	if is_in_collision_layer(body, COLLISION_LAYER_ENVIRONMENT):
		bounces += 1
		if bounces > attributes.bounce:
			queue_free()
