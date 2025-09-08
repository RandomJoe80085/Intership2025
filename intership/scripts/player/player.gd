extends CharacterBody2D
class_name Player

signal update_added()

@export var walk_speed = 200
@export_range(0,1) var decelaration = 0.1
@export_range(0,1) var aceceleration = 0.1
@export var jump_force = -400.0
@export_range(0,1) var decelarate_on_jump_release = 0.5
@export var attack_damage = 10
@export var knockback_force = 100
@export var dash_speed = 250
@export var max_dash_count = 1
var upgrades : Array[BaseUpgradeStrategy] = []
var upgrades_id : Array[Vector2] = []
@export var after_dash_invulnerability = 0.3


@onready var dash_bar: ProgressBar = $CanvasLayer/DashBar
@onready var dash_duration: Timer = $DashDuration
@onready var dash_cooldown = $DashCooldown
@onready var coyote_timer = $CoyoteTimer
@onready var death_menu: DeathMenu = $CanvasLayer/DeathMenu
@onready var player_animation: AnimatedSprite2D = $PlayerAnimation
@onready var knockback_component: KnockbackComponent = $KnockbackComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var dash_count_label: Label = $CanvasLayer/DashCountLabel



var dash_count = max_dash_count
var is_dashing = false
var has_landed = true
var has_jumped = false
var dash_start_position : Vector2 
var dash_direction : Vector2


func _ready():
	dash_count_label.text = str("x", dash_count)
	dash_bar.max_value = dash_cooldown.wait_time
	dash_bar.value = dash_bar.max_value
	if PlayerRespawn.player_respawn_position:
		global_position = PlayerRespawn.player_respawn_position
	upgrades.clear()
	upgrades = PlayerUpgrades.get_upgrades().duplicate()
	upgrades_id = PlayerUpgrades.get_upgrades_id()
	for upgrade in upgrades:
		apply_upgrade_to_player(upgrade)

func _physics_process(delta: float) -> void:
	print(upgrades)
	dash_bar.value = dash_bar.max_value- dash_cooldown.time_left
	movement(delta)
	

func movement(delta: float) -> void:
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall()
	var direction := Input.get_axis("move_left", "move_right")
	
	
	handle_wall_jump(delta)
	
	handle_dash()
	
	handle_jump()
	
	flip_by_direction(direction)
	
	handle_jump()
	
	move_and_slide()
	
	start_coyotee_timer(was_on_floor,was_on_wall)

func start_coyotee_timer(was_on_floor: bool, was_on_wall: bool):
	if (was_on_floor and !is_on_floor()) or (was_on_wall and is_on_wall()):
		coyote_timer.start()

func handle_wall_jump(delta: float) -> void:
	if knockback_component and knockback_component.is_knockbacked:
		knockback_component.update_knockback(delta)
	else:if not is_on_floor():
		if is_on_wall() and velocity.y > 0 and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
			velocity += (get_gravity() * delta)/10
			has_landed = true
			has_jumped = false
		elif is_on_wall() and velocity.y < 0 and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
			velocity += get_gravity() * delta
			has_jumped = true
			has_landed = false
		else:
			velocity += get_gravity() * delta
	else:
		has_landed = true
		has_jumped = false

func handle_dash():
	
	if Input.is_action_just_pressed("dash") and dash_cooldown.is_stopped():# and not is_dashing and dash_cooldown.is_stopped() and dash_count > 0:
		if dash_count > 0:
			is_dashing = true
			has_landed = false
			dash_count -= 1
			update_dash_label()
			dash_start_position = position
			dash_direction = get_global_mouse_position() - global_position
			health_component.invulnerability_timer = dash_duration.wait_time + after_dash_invulnerability
			health_component.is_invulnerable = true
			dash_duration.start()
			
			
		if dash_count == 0:
			dash_cooldown.start()
	
	if is_dashing and !dash_duration.is_stopped():
		if is_on_wall() or is_on_ceiling():
			is_dashing = false
			has_landed = true
			dash_duration.stop()
			player_animation.rotation_degrees = 0
		else:
			velocity = dash_direction.normalized() * dash_speed
			player_animation.rotate(1) 

func handle_jump():
	if Input.is_action_just_pressed("jump") and has_landed and !has_jumped and(is_on_floor() or is_on_wall() or !coyote_timer.is_stopped() and velocity.y > 0):
		velocity.y = jump_force
		has_jumped = true
	if Input.is_action_just_released("jump") and velocity.y < 0 :
		velocity.y *= decelarate_on_jump_release

func flip_by_direction(direction) -> void:
	if direction <0:
		player_animation.flip_h = true
	if direction > 0:
		player_animation.flip_h = false
	if direction:
		velocity.x = move_toward(velocity.x, direction * walk_speed, walk_speed * aceceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * decelaration)

func _on_dash_duration_timeout() -> void:
	is_dashing = false
	player_animation.rotation_degrees = 0

func apply_upgrade_to_player(upgrade: BaseUpgradeStrategy):
	upgrade.apply_upgrade(self)
	emit_signal("update_added")

func add_upgrade_id(id:Vector2):
	upgrades_id.append(id)

func update_dash_label():
	dash_count_label.text = str("x", dash_count)

func _on_health_component_has_died() -> void:
	death_menu.show_death_screen()

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	dash_count = max_dash_count
	dash_count_label.text = str("x", dash_count)
