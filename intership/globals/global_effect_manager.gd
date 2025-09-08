extends Node

const DAMAGE_TEXT = preload("res://globals/damage_text.tscn")

func damage_text(damage: int, postition: Vector2) -> void:
	var text: DamageText = DAMAGE_TEXT.instantiate()
	add_child(text)
	text.start(damage, postition)
	pass
