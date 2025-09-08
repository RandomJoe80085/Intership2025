extends Area2D

@export var upgrade_strategy: BaseUpgradeStrategy

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.upgrades.append(upgrade_strategy)
		body.apply_upgrade_to_player(upgrade_strategy)
		queue_free()
