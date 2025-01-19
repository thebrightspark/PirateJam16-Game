extends Resource
class_name ProjectileAttributes

@export var damage = 2
@export var lifetime = 5
@export var speed = 200
@export var drag = 1.0 # FIXME: Can't get forces to apply :(
@export var gravity = 0.0
@export var knockback = 0.0 # TODO
@export var aoe_range = 0.0 # TODO
@export var bounce = 0
@export var pierce = 0
@export var homing = false # TODO: Once drag works
@export var homing_range = 20
