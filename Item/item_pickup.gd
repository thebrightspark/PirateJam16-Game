extends RigidBody2D

@export var modifier: BaseModifier

func _on_player_entered(body: Node2D) -> void:
	body.add_modifier(modifier)
	self.queue_free()
