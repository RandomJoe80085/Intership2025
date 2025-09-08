extends Node2D
class_name Laser

@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $RayCast2D/Line2D


@export var attack_damage:int = 10
@export var is_casting = false: set = set_is_casting
@export var cast_speed = 700
@export var max_lenght = 1400
@onready var gpu_particles_2d_2: GPUParticles2D = $GPUParticles2D2

var attack:Attack = Attack.new()

func _ready() -> void:
	set_is_casting(is_casting)
	attack.attack_damage = attack_damage

func _physics_process(delta: float) -> void:
	ray_cast_2d.target_position.x = move_toward(ray_cast_2d.target_position.x,max_lenght,cast_speed*delta)
	ray_cast_2d_2.target_position.x = move_toward(ray_cast_2d_2.target_position.x,max_lenght,cast_speed*delta)
	var laser_end_position = ray_cast_2d.target_position
	
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		laser_end_position = to_local(ray_cast_2d.get_collision_point())
	line_2d.points[1] = laser_end_position
	gpu_particles_2d_2.position = laser_end_position
	if ray_cast_2d_2.is_colliding():
		var collided_object:Node2D = ray_cast_2d_2.get_collider()
		print(collided_object)
		if collided_object.name == "HitboxComponent":
			collided_object.damage(attack)



func set_is_casting(new_value:bool)->void:
	if is_casting == new_value:
		return
	is_casting = new_value
	
	set_physics_process(is_casting)
	
	if is_casting == false:
		ray_cast_2d.target_position.x = 0
