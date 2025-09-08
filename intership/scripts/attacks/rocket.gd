extends Area2D
class_name Rocket

@export var target: Node2D = null
@export var has_target:bool = false
const EXPLOSION = preload("res://scenes/attacks/explosion.tscn")
@export var attack_damage:int = 10
@export var knockback_force:int = 100
@export var speed = 200
@export var rotation_speed := 3  # radians per second (adjust for slower/faster rotation)
@export var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	if target:
		has_target = true

func _physics_process(delta: float) -> void:
	if has_target:
		# Calculate direction to target
		var direction_to_target = (target.global_position - global_position).normalized()
		
		# Calculate target angle
		var target_angle = direction_to_target.angle()
		
		# Smoothly rotate towards target
		global_rotation = lerp_angle(global_rotation, target_angle, rotation_speed * delta)
		
		# Move forward in current facing direction
		global_position += Vector2.RIGHT.rotated(global_rotation) * speed * delta
	else:
		global_rotation = direction.angle()
		global_position += speed * direction * delta 

func _on_body_entered(body: Node2D) -> void:
	# Use call_deferred to safely disable monitoring and free the node
	call_deferred("handle_collision", body)

func handle_collision(body: Node2D):
	# Disable monitoring first to prevent further collisions
	monitoring = false
	
	# Create explosion
	var explosion_scene = EXPLOSION.instantiate()
	get_tree().current_scene.add_child(explosion_scene)
	explosion_scene.explode(global_position, attack_damage, knockback_force)
	
	# Free the rocket
	queue_free()
