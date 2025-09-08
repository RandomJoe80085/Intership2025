extends Area2D
class_name HitboxComponent

@export var health_component: HealthComponent
var attack: Attack = null

func set_attack(_attack: Attack):
	attack = _attack

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)

func _on_area_entered(area: Area2D) -> void:
	# Check if the entered area is a HitboxComponent and we have an attack
	if area is HitboxComponent and attack:
		var hitbox: HitboxComponent = area
		# Make sure the hitbox has a health component before trying to use it
		if hitbox.health_component:
			hitbox.health_component.add_attack(attack)
			hitbox.health_component.damage(attack)

func _on_area_exited(area: Area2D) -> void:
	# Check if the exited area is a HitboxComponent and we have an attack
	if area is HitboxComponent and attack:
		var hitbox: HitboxComponent = area
		# Make sure the hitbox has a health component before trying to use it
		if hitbox.health_component:
			hitbox.health_component.remove_attack(attack)
