extends Node2D
class_name HealthComponent

signal has_died
signal hit

@export var MAX_HEALTH = 10
@export var parent: Node2D
@export var sprite: AnimatedSprite2D
@export var invulnerability_duration := 1.0
@export var flash_interval := 0.1  # Time between flashes
@export var is_player: bool = false
@export var healthbar: ProgressBar

@onready var incoming_attacks: Array[Attack] = []

var health: float
var is_invulnerable = false
var invulnerability_timer: float = 0.0
var flash_timer: float = 0.0

func _ready() -> void:
	health = MAX_HEALTH
	if parent.name == "Player":
		is_player = true
	if healthbar:
		healthbar.max_value = MAX_HEALTH
		healthbar.value = health
		if not is_player:
			healthbar.visible = false
		else:
			healthbar.visible = true

func _process(delta: float) -> void:
	if is_invulnerable:
		invulnerability_timer -= delta
		flash_timer -= delta

		if sprite and flash_timer <= 0.0:
			sprite.modulate.a = 0.2 if sprite.modulate.a > 0.5 else 1.0
			flash_timer = flash_interval

		if invulnerability_timer <= 0.0:
			is_invulnerable = false
			if sprite:
				sprite.modulate.a = 1.0  # Ensure visible
			if incoming_attacks:
				for attack in incoming_attacks:
					damage(attack)

func damage(attack: Attack):
	if not is_invulnerable:
		health -= attack.attack_damage
		emit_signal("hit")
		EffectManager.damage_text(attack.attack_damage, global_position)
		update_healthbar()
		if healthbar:
			healthbar.visible = true
		var knockback = parent.get_node_or_null("KnockbackComponent")
		if knockback:
			var direction = (parent.global_position - attack.attack_position).normalized()
			knockback.take_knockback(direction * attack.knockback_force)

		# Trigger hit-based invulnerability
		is_invulnerable = true
		invulnerability_timer = invulnerability_duration
		flash_timer = flash_interval

	if health <= 0:
		emit_signal("has_died")

func remove_attack(attack: Attack):
	incoming_attacks.erase(attack)
	
	
func add_attack(attack: Attack):
	incoming_attacks.append(attack)
	
func heal(value: int):
	health += value
	if health >= MAX_HEALTH:
		health = MAX_HEALTH
	update_healthbar()

func update_healthbar():
	if healthbar:
		healthbar.value = health
