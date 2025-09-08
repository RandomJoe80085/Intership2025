extends Node

var upgrades : Array[BaseUpgradeStrategy] = []
var upgrades_id : Array[Vector2] = []

func add_id(_position:Vector2) -> void:
	upgrades_id.append(_position)

func add_upgrades(_upgrades: Array[BaseUpgradeStrategy]) -> void:
	upgrades = _upgrades

func clear_upgrades() -> void:
	upgrades.clear()

func get_upgrades() ->Array[BaseUpgradeStrategy]:
	return upgrades.duplicate()

func get_upgrades_id() ->Array[Vector2]:
	return upgrades_id.duplicate()

func add_ids(ids: Array[Vector2]):
	upgrades_id = ids.duplicate()

func check_for_upgrade_by_position(_position) -> bool:
	for upgrade in upgrades_id:
		if upgrade == _position:
			return true
	return false
