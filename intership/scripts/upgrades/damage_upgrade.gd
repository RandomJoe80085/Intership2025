extends Area2D

@export var upgrade_strategy: BaseUpgradeStrategy
func _ready() -> void:
	if PlayerUpgrades.check_for_upgrade_by_position(global_position):
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.upgrades.append(upgrade_strategy)
		body.add_upgrade_id(global_position)
		body.apply_upgrade_to_player(upgrade_strategy)
		queue_free()
