extends CharacterBody2D


const SPEED = 3000
var direction = 1

@onready var ray_cast_left_down: RayCast2D = $RayCastLeftDown
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_right_down: RayCast2D = $RayCastRightDown

func _process(delta: float) -> void:
	#if ray_cast_right.is_colliding() or not ray_cast_right_down.is_colliding():
		#direction = -1
	#if ray_cast_left.is_colliding() or not ray_cast_left_down.is_colliding():
		#direction = 1
	
	
	position.x = direction * SPEED * delta
	move_and_slide()
