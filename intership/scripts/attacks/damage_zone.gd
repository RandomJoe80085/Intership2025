extends Area2D
class_name DamageZone
var attack:Attack = Attack.new()
@export var attack_damage = 10

func _ready() -> void:
	attack.attack_damage = attack_damage

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		area.health_component.add_attack(attack)
		hitbox.damage(attack)



func _on_area_exited(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		area.health_component.remove_attack(attack)
