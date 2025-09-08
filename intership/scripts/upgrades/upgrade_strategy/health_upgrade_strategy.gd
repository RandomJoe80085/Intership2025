extends BaseUpgradeStrategy
class_name HealthUpgradeStrategy

@export var heal: int = 10

func apply_upgrade(player: Player):
	player.health_component.heal(heal)
	
