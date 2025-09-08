extends CharacterBody2D
@export var attack_damage = 10
@export var knockback_force = 100
var attack:Attack = Attack.new()
@export var speed = 3000
var direction = Vector2.RIGHT



var player: Node2D = null
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var knockback_component: Node2D = $KnockbackComponent
@onready var ray_cast_left_down: RayCast2D = $RayCastLeftDown
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_right_down: RayCast2D = $RayCastRightDown
var death_particles_scene = preload("res://scripts/enemies/death_particles.tscn")

func _ready() -> void:
	attack.attack_damage =attack_damage
	attack.knockback_force = knockback_force
	attack.attack_position = global_position
	hitbox_component.set_attack(attack)

func _process(delta: float) -> void:
	if knockback_component and knockback_component.is_knockbacked:
		knockback_component.update_knockback(delta)
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta
		else:
			if player:
				direction = (player.global_position - global_position).normalized()
				if direction.x < 0:
					direction = Vector2.LEFT
				else:
					direction = Vector2.RIGHT
			elif ray_cast_right.is_colliding() or not ray_cast_right_down.is_colliding():
				direction = Vector2.LEFT
			elif ray_cast_left.is_colliding() or not ray_cast_left_down.is_colliding():
				direction = Vector2.RIGHT
			velocity = direction * speed * delta
	move_and_slide()
	


func _on_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body


func _on_detection_body_exited(body: Node2D) -> void:
		if body.name == "Player":
			player = null
	


func _on_health_component_has_died() -> void:
	var death_particles = death_particles_scene.instantiate()
	get_tree().current_scene.add_child(death_particles)
	var emit_position: Vector2 = global_position
	emit_position.y -= 10 
	death_particles.emit_particles(emit_position)
	queue_free()
