extends BaseUpgradeStrategy
class_name DashUpgradeStrategy

func apply_upgrade(player: Player):
	player.max_dash_count += 1
	player.dash_count = player.max_dash_count
	player.update_dash_label()
