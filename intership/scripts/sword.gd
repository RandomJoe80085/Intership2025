extends Node2D


var current_rotation_speed := 0.0
var max_rotation_speed := 12.0  # radians per second
var rotation_acceleration := 10.0  # radians per second squared

func _physics_process(delta):
	var mouse_global_pos = get_global_mouse_position()

	var direction = (mouse_global_pos - global_position).normalized()
	var target_angle = direction.angle()

	# Normalize angles to avoid spinning the long way
	var angle_difference = wrapf(target_angle - global_rotation, -PI, PI)

	# Accelerate rotation speed
	current_rotation_speed += rotation_acceleration * delta
	current_rotation_speed = min(current_rotation_speed, max_rotation_speed)

	# Determine how much to rotate this frame (limited by speed)
	var rotation_step = clamp(angle_difference, -current_rotation_speed * delta, current_rotation_speed * delta)

	global_rotation += rotation_step
