extends Resource
class_name BaseModifier

@export var name: String
@export var texture: Texture2D
@export var bandwidth = 10
@export var type: Array[ModifierType]
@export var tier: ModifierTier
@export_category("Sprite Colors")
@export var background_color: Color = Color("af0000")
@export var border_color: Color = Color("898989")
@export var circuit_color: Color = Color("ffff00")
@export var chip_color: Color = Color("fb0000")
