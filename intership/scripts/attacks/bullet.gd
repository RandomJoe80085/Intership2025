extends Area2D
class_name Bullet

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var speed: float = 400.0
@export var attack_damage = 10
@export var knockback_force = 100
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		global_position += direction.normalized() * speed * delta




func _on_area_entered(area) -> void:
	if area is HitboxComponent:
		
		var hitbox : HitboxComponent = area
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		hitbox.damage(attack)


func _on_body_entered(body: Node2D) -> void:
		queue_free()
	
