extends Node2D

@onready var marker_2d: Marker2D = $Marker2D

@onready var sprite_2d_2: Sprite2D = $Sprite2D2

func _on_area_2d_body_entered(body: Player) -> void:
	PlayerRespawn.set_respawn_position(marker_2d.global_position)
	sprite_2d_2.modulate.r = 0
	sprite_2d_2.modulate.b = 0
	PlayerUpgrades.add_upgrades(body.upgrades.duplicate())
	PlayerUpgrades.add_ids(body.upgrades_id.duplicate())
