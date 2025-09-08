extends Node

var player_respawn_position: Vector2

func set_respawn_position(position:Vector2)->void:
	player_respawn_position = position
	print(player_respawn_position)
