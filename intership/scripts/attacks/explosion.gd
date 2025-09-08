extends Area2D
class_name Explosion

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func explode(pos: Vector2, attack_damage: int, knockback_force: int):
	global_position = pos
	
	# Force a physics frame update
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	var areas = get_overlapping_areas()
	
	for area in areas:
		if area is HitboxComponent:
			var hitbox : HitboxComponent = area
			var attack = Attack.new()
			attack.attack_damage = attack_damage
			attack.knockback_force = knockback_force
			attack.attack_position = pos
			hitbox.damage(attack)
	
	await animation_player.animation_finished
	queue_free()
