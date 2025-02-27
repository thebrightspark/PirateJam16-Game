extends RigidBody2D

@export var base_damage: int = 1
@export var attributes: ProjectileAttributes = ProjectileAttributes.new()
@export var AudioPlayer: AudioStreamPlayer2D

@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var light: PointLight2D = $PointLight2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider_env: CollisionShape2D = $EnvironmentCollider
@onready var collider_enemy: CollisionShape2D = $Area2D/EnemyCollider
@onready var death_delay_timer: Timer = $DeathDelay

const COLLISION_LAYER_ENVIRONMENT = 2
const COLLISION_LAYER_ENEMY = 5
var projectile: PackedScene = preload("res://Projectile/projectile.tscn")

var dead = false
var age: float = 0
var bounces = 0
var pierced = 0

func _ready() -> void:
	apply_central_impulse(Vector2(0, -attributes.speed).rotated(global_rotation).rotated(deg_to_rad(90)))
	play_sfx()

func _process(delta: float) -> void:
	handle_age(delta)

func _physics_process(_delta: float) -> void:
	look_at(global_position + linear_velocity)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if dead:
		return
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

func _on_death_delay_timeout() -> void:
	queue_free()

func kill() -> void:
	if death_delay_timer.is_stopped():
		death_delay_timer.start()
		dead = true
		particles.emitting = false
		light.enabled = false
		sprite.visible = false
		call_deferred("kill_actions_deferred")

func kill_actions_deferred() -> void:
	collider_env.disabled = true
	collider_enemy.disabled = true
	freeze = true

func play_sfx() -> void:
	var pitch = randf_range(0.8, 1.2)
	AudioPlayer.pitch_scale = pitch
	AudioPlayer.play()
	return

func handle_age(delta: float) -> void:
	if dead:
		return
	age += 1.0 * delta
	if age >= attributes.lifetime:
		kill()

func handle_enemy_hit(body: Node2D) -> void:
	if dead:
		return
	if Util.is_in_collision_layer(body, "Enemies") && body.has_method("on_damage"):
		body.on_damage(base_damage + attributes.damage)
		pierced += 1
		if pierced > attributes.pierce:
			kill()
		else:
			add_collision_exception_with(body)

func handle_bounce(body: Node) -> void:
	if dead:
		return
	if Util.is_in_collision_layer(body, "Environment"):
		bounces += 1
		if bounces > attributes.bounce:
			kill()
