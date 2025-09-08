extends Node2D

var is_seeing_player = false
var player: Node2D = null

@onready var turret_cannon: Sprite2D = $LockArea/TurretCannon
@onready var marker_2d: Marker2D = $LockArea/TurretCannon/Marker2D
var bullet_scene = preload("res://scenes/attacks/bullet.tscn")

# Cooldown tracking
var can_shoot := true
var shoot_cooldown := 1.0  # seconds
var shoot_timer := 0.0

func _process(delta: float) -> void:
	if is_seeing_player and player:
		turret_cannon.look_at(player.global_position)

		if can_shoot:
			shoot()
			can_shoot = false
			shoot_timer = shoot_cooldown
		else:
			# Decrease the cooldown timer
			shoot_timer -= delta
			if shoot_timer <= 0.0:
				can_shoot = true

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = marker_2d.global_position
	bullet.direction = (player.global_position - marker_2d.global_position).normalized()
	bullet.speed = 200
	get_tree().current_scene.add_child(bullet)

func _on_lock_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_seeing_player = true
		player = body

func _on_lock_area_body_exited(body: Node2D) -> void:
	if body == player:
		is_seeing_player = false
		player = null
