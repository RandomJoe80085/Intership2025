extends StaticBody2D
class_name Door
@export var is_open : bool

@onready var sprite_2d: Sprite2D = $Sprite2D

func open():
	collision_layer = 0
	sprite_2d.modulate.a = 0.5
