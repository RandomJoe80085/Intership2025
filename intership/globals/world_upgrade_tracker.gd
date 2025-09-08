extends Node

var upgrades: Array[Vector2] = []  

func add_upgrade(upgrade: Vector2) -> void:
	upgrades.append(upgrade)

func check_upgrade(_position: Vector2) -> bool:
	if _position in upgrades:
		return true
	return false
