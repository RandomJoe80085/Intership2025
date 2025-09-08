
extends Resource
class_name BaseUpgradeStrategy

var upgrade_strategy: BaseUpgradeStrategy
var upgrade_id

func generate_id(_position: Vector2):
	upgrade_id = _position

func apply_upgrade(_player: Player):
	pass
