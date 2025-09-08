extends Node2D


class_name KnockbackComponent

@export var parent: CharacterBody2D
var velocity: Vector2 = Vector2.ZERO
var is_knockbacked: bool = false
var knockback_timer: float = 0.0
@export var knockback_duration: float = 0.2

func take_knockback(knockback: Vector2):
	velocity = knockback
	is_knockbacked = true
	knockback_timer = knockback_duration

func update_knockback(delta: float):
	if is_knockbacked:
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			is_knockbacked = false
			velocity = Vector2.ZERO
		parent.velocity = velocity
