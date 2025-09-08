extends Node2D
class_name Sword

@onready var player: Player = $".."
@onready var marker_2d: Marker2D = $Marker2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var base_attack_damage
var base_knockback_force
var attack_damage
var knockback_force
var is_blocking = false

var current_rotation_speed := 0.0
@export var max_rotation_speed := 20.0  # radians per second
@export var rotation_acceleration := 150.0  # radians per second squared
@export var rotation_deceleration := 70
@export var angle_tolerance = 0.05  # Radians (~0.5 degrees)

# Rotation tracking variables
var total_rotation := 0.0
var previous_rotation := 0.0
var has_rotated_270_degrees := false
var rotation_count := 0

# Direction tracking
var current_direction := 0  # 0 = no direction, 1 = clockwise, -1 = counterclockwise
var consistent_direction_rotation := 0.0  # Tracks rotation in current direction only

# Bonus damage system
var bonus_damage_active := false
var bonus_damage_timer := 0.0
@export var bonus_damage_duration := 1.0  # 1 second duration
@export var bonus_damage_multiplier := 1.5  # 50% bonus damage

# Airborne rotation tracking
var airborne_rotations := 0  # Counts rotations while in air
var min_airborne_rotations := 1  # Minimum rotations required for bonus
var was_in_air := false  # Track previous air state

func _ready():
	player.update_added.connect(_on_player_update_added)
	initialize_sword()

func _physics_process(delta):
	update_sword_state(delta)

func initialize_sword():
	base_attack_damage = player.attack_damage
	knockback_force = player.knockback_force + player.attack_damage * 5
	previous_rotation = global_rotation

func update_sword_state(delta):
	handle_blocking()
	calculate_damage()
	update_bonus_damage(delta)
	check_landing()
	rotate_towards_mouse(delta)

func handle_blocking():
	is_blocking = Input.is_action_pressed("block")
	
	sprite_2d.modulate.r = 0 if is_blocking else 1

func calculate_damage():
	attack_damage = base_attack_damage + base_attack_damage * ((abs(player.velocity.x) + abs(player.velocity.y)) / 1000.0)

func update_bonus_damage(delta):
	if bonus_damage_active:
		bonus_damage_timer -= delta
		if bonus_damage_timer <= 0:
			end_bonus_damage()

func end_bonus_damage():
	bonus_damage_active = false
	sprite_2d.modulate = Color(1, 1, 1)

func check_landing():
	if was_in_air and not is_in_air():
		reset_airborne_rotations()
		end_bonus_damage()
	was_in_air = is_in_air()

func reset_airborne_rotations():
	airborne_rotations = 0

func is_in_air() -> bool:
	return player.has_jumped

func rotate_towards_mouse(delta):
	var mouse_global_pos = get_global_mouse_position()
	var direction = (mouse_global_pos - global_position).normalized()
	var target_angle = direction.angle()

	# Normalize angles to avoid spinning the long way
	var angle_difference = wrapf(target_angle - global_rotation, -PI, PI)

	# Accelerate rotation speed
	if abs(angle_difference) > angle_tolerance:
		current_rotation_speed += rotation_acceleration * delta
		current_rotation_speed = min(current_rotation_speed, max_rotation_speed)
	else:
		current_rotation_speed = max(current_rotation_speed - rotation_deceleration * delta, 0.0)

	# Determine how much to rotate this frame (limited by speed)
	var rotation_step = clamp(angle_difference, -current_rotation_speed * delta, current_rotation_speed * delta)
	global_rotation += rotation_step
	
	# Track cumulative rotation with direction checking
	track_rotation()

func track_rotation():
	# Calculate the actual rotation change (handling wrap-around)
	var rotation_change = wrapf(global_rotation - previous_rotation, -PI, PI)
	
	update_rotation_direction(rotation_change)
	
	# Only accumulate rotation if moving in a consistent direction
	if current_direction != 0:
		consistent_direction_rotation += abs(rotation_change)
	
	total_rotation += abs(rotation_change)
	previous_rotation = global_rotation
	
	check_270_degree_rotation()

func update_rotation_direction(rotation_change: float):
	# Determine current rotation direction
	var new_direction = 0
	if abs(rotation_change) > 0.001:  # Small threshold to ignore tiny movements
		new_direction = sign(rotation_change)
	
	# Check if direction changed
	if new_direction != 0 and new_direction != current_direction:
		if current_direction != 0:  # If we were already moving in a direction
			# Direction changed - reset consistent rotation
			consistent_direction_rotation = 0.0
		current_direction = new_direction

func check_270_degree_rotation():
	# 270 degrees in radians (270 * PI/180)
	var target_rotation_radians = deg_to_rad(230)
	
	# Check if we've completed a 270-degree rotation in ONE consistent direction
	if consistent_direction_rotation >= target_rotation_radians and not has_rotated_270_degrees:
		handle_270_degree_rotation()
	
	# Reset flag when rotation drops below threshold
	elif consistent_direction_rotation < target_rotation_radians and has_rotated_270_degrees:
		has_rotated_270_degrees = false

func handle_270_degree_rotation():
	has_rotated_270_degrees = true
	rotation_count += 1
	
	# Only count as airborne rotation if player is in the air
	if is_in_air() and not is_blocking:
		airborne_rotations += 1
		activate_bonus_damage()
	
	consistent_direction_rotation = 0.0  # Reset for next rotation

func activate_bonus_damage():
	# Activate bonus damage for 1 second
	bonus_damage_active = true
	bonus_damage_timer = bonus_damage_duration
	
	# Visual feedback - different colors for different directions
	if current_direction > 0:
		sprite_2d.modulate = Color(1, 0.5, 0.5)  # Red tint for clockwise
	else:
		sprite_2d.modulate = Color(0.5, 0.5, 1)  # Blue tint for counterclockwise

func _on_area_entered(area) -> void:
	if area is HitboxComponent:
		handle_hitbox_collision(area)
	elif area is Bullet:
		handle_bullet_collision(area)
	elif area is Rocket:
		handle_rocket_collision(area)

func handle_hitbox_collision(area):
	var hitbox: HitboxComponent = area
	if not is_blocking and (current_rotation_speed > 6 or player.velocity != Vector2.ZERO):
		var attack = create_attack()
		hitbox.damage(attack)

func create_attack() -> Attack:
	var attack = Attack.new()
	attack.attack_damage = calculate_final_damage()
	attack.knockback_force = knockback_force
	attack.attack_position = marker_2d.global_position
	return attack

func calculate_final_damage() -> float:
	var final_damage = attack_damage
	
	# Apply bonus damage only if active AND player is in the air
	if bonus_damage_active and is_in_air():
		final_damage *= bonus_damage_multiplier
	elif bonus_damage_active:
		# Bonus was active but player landed - cancel bonus
		end_bonus_damage()
	
	return final_damage

func handle_bullet_collision(area):
	var bullet: Bullet = area
	if is_blocking and current_rotation_speed > 6:
		deflect_bullet(bullet)

func deflect_bullet(bullet: Bullet):
	bullet.direction = -bullet.direction
	var sprite = bullet.get_node_or_null("AnimatedSprite2D")
	if sprite:
		sprite.modulate.r = 0
	bullet.collision_layer = 1 << 1
	bullet.collision_mask = (1 << 2) | (1 << 3)

func _on_player_update_added():
	initialize_sword()

func handle_rocket_collision(area):
	var rocket: Rocket = area
	if is_blocking and current_rotation_speed > 6:
		deflect_rocket(rocket)

func deflect_rocket(rocket:Rocket):
	rocket.direction = (rocket.global_position - player.global_position).normalized()
	rocket.has_target = false
	var sprite = rocket.get_node_or_null("Sprite2D")
	if sprite:
		sprite.modulate.r = 0
