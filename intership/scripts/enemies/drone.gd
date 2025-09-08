extends CharacterBody2D

@export var speed = 3000
@export var attack_damage = 10
@export var knockback_force = 200
@onready var knockback_component: KnockbackComponent = $KnockbackComponent

var direction = Vector2.ZERO
var player: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if knockback_component and knockback_component.is_knockbacked:
		knockback_component.update_knockback(delta)
	else:
		if player:
			direction = (player.global_position - global_position).normalized()
			velocity = speed * direction * delta
	move_and_slide()



func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body




func _on_hitbox_component_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		hitbox.damage(attack)
