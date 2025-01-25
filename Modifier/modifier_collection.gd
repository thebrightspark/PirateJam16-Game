extends Resource
class_name ModifierCollection

@export var modifiers: Array[BaseModifier] = []

var bandwidth: int = 0
var bounce: int = 0
var cooldown: int = 0
var damage: float = 0.0
var health: int = 0
var homing: bool = false
var lifesteal: int = 0
var multishot: int = 0
var pierce: int = 0

func create_projectile_attributes() -> ProjectileAttributes:
	var attributes = ProjectileAttributes.new()
	attributes.bounce = bounce
	attributes.damage = damage
	attributes.homing = homing
	attributes.pierce = pierce
	return attributes

func get_modifier(index: int) -> BaseModifier:
	return modifiers[index] if index >= 0 and index < modifiers.size() else null

func set_modifiers(new_modifiers: Array[BaseModifier]) -> void:
	modifiers.clear()
	bandwidth = 0
	bounce = 0
	cooldown = 0
	damage = 0.0
	health = 0
	homing = false
	lifesteal = 0
	multishot = 0
	pierce = 0
	for modifier in new_modifiers:
		if modifier is BaseModifier:
			bandwidth += modifier.bandwidth
			add_modifier(modifier)
		else:
			print(modifier, " is not a BaseModifier")

func add_modifier(modifier: BaseModifier) -> void:
	modifiers.append(modifier)
	if modifier is BounceModifier:
		bounce += (modifier as BounceModifier).bounce
	elif modifier is CooldownModifier:
		cooldown += (modifier as CooldownModifier).cooldown_reduction_ms
	elif modifier is DamageModifier:
		damage += (modifier as DamageModifier).damage
	elif modifier is HealthModifier:
		health += (modifier as HealthModifier).health
	elif modifier is HomingModifier:
		homing = homing or (modifier as HomingModifier).homing
	elif modifier is LifestealModifier:
		lifesteal += (modifier as LifestealModifier).lifesteal_percentage
	elif modifier is MultishotModifier:
		multishot += (modifier as MultishotModifier).multishot
	elif modifier is PierceModifier:
		pierce += (modifier as PierceModifier).pierce
	else:
		printerr("Unhandled modifier type: ", typeof(modifier))

func remove_modifier(index: int) -> void:
	var removed = modifiers.pop_at(index)
	if removed is BounceModifier:
		bounce -= (removed as BounceModifier).bounce
	elif removed is CooldownModifier:
		cooldown -= (removed as CooldownModifier).cooldown_reduction_ms
	elif removed is DamageModifier:
		damage -= (removed as DamageModifier).damage
	elif removed is HealthModifier:
		health -= (removed as HealthModifier).health
	elif removed is HomingModifier:
		homing = modifiers.any(func(m): return m is HomingModifier and (m as HomingModifier).homing)
	elif removed is LifestealModifier:
		lifesteal -= (removed as LifestealModifier).lifesteal_percentage
	elif removed is MultishotModifier:
		multishot -= (removed as MultishotModifier).multishot
	elif removed is PierceModifier:
		pierce -= (removed as PierceModifier).pierce
	else:
		printerr("Unhandled modifier type: ", typeof(removed))
