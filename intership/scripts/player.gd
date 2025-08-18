extends CharacterBody2D

@export var walk_speed = 200
@export_range(0,1) var decelaration = 0.1
@export_range(0,1) var aceceleration = 0.1
@export var jump_force = -400.0
@export_range(0,1) var decelarate_on_jump_release = 0.5

@export var dash_speed = 400

@export var max_jump_count = 4
@export var max_dash_count = 1

var dash_count = max_dash_count
var jump_count = max_jump_count
var is_dashing = false
var has_landed = true
var has_jumped = false
var dash_start_position : Vector2 
var dash_direction : Vector2
@onready var dash_duration: Timer = $DashDuration
@onready var dash_cooldown = $DashCooldown
@onready var coyote_timer = $CoyoteTimer


func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall()
	print(is_dashing)
	if not is_on_floor():
		if is_on_wall() and velocity.y > 0 and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
			velocity += (get_gravity() * delta)/10
			has_landed = true
			has_jumped = false
			jump_count = max_jump_count
			dash_count = max_dash_count
		elif is_on_wall() and velocity.y < 0 and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
			velocity += get_gravity() * delta
			has_jumped = true
			has_landed = false
			jump_count = max_jump_count
			dash_count = max_dash_count
		else:
			velocity += get_gravity() * delta
	else:
		has_landed = true
		has_jumped = false
		jump_count = max_jump_count
		dash_count = max_dash_count
		
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and has_landed and !has_jumped and jump_count > 0 and(is_on_floor() or is_on_wall() or !coyote_timer.is_stopped() and velocity.y > 0):
		velocity.y = jump_force
		has_jumped = true
		jump_count -= 1
	if Input.is_action_just_released("jump") and velocity.y < 0 :
		velocity.y *= decelarate_on_jump_release

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * walk_speed, walk_speed * aceceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * decelaration)
	
	if Input.is_action_just_pressed("dash") and not is_dashing and dash_cooldown.is_stopped() and dash_count > 0: #dand has_landed == true:
		is_dashing = true
		has_landed = false
		dash_count -= 1
		dash_start_position = position
		dash_direction = get_global_mouse_position() - global_position
		dash_cooldown.start()
		dash_duration.start()
	
	if is_dashing and !dash_duration.is_stopped():
		if is_on_wall() or is_on_ceiling():
			is_dashing = false
			dash_duration.stop()
			$PlayerAnimation.rotation_degrees = 0
		
		else:
			velocity = dash_direction.normalized() * dash_speed
			$PlayerAnimation.rotate(1) 
	
	
	move_and_slide()
	
	if (was_on_floor and !is_on_floor()) or (was_on_wall and is_on_wall()):
		coyote_timer.start()
	

func _on_dash_cooldown_timeout() -> void:
	is_dashing = false


func _on_dash_duration_timeout() -> void:
	is_dashing = false
	$PlayerAnimation.rotation_degrees = 0
