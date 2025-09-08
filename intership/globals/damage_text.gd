class_name DamageText extends Node2D

var travel_distance: Vector2 = Vector2(10, -20)

func start(damage: int, postition: Vector2 ) -> void:
	$Label.text = str(damage)
	global_position = postition
	
	travel_distance.y *= randf_range(0.5,1.5)
	travel_distance.x *= randf_range(-1.5,1.5)
	
	var duration = 1
	
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self,"global_position", global_position + travel_distance, duration)
	tween.chain().tween_callback(self.queue_free)
	pass
