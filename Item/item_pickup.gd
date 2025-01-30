extends RigidBody2D

@export var modifier: BaseModifier

func _on_player_entered(body: Node2D) -> void:
	if body is Player:
		var inv: Inventory = (body as Player).data.inventory
		if inv.add_modifier(modifier):
			self.queue_free()
