extends BaseUpgradeStrategy
class_name DamageUpgradeStrategy

@export var damage_increase = 5

func apply_upgrade(player: Player):
	player.attack_damage += damage_increase
