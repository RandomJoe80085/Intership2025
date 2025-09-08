extends Node2D
class_name SpikeBall

@export var end_1: Marker2D 
@export var end_2: Marker2D 
@export var time = 1


func _ready() -> void:
	if end_1 and end_2:
		global_position = end_1.global_position
		var tween = create_tween()
		tween.set_loops()  # Infinite loops
		
		# Bounce scale back and forth
		tween.tween_property(self, "global_position", end_2.global_position, time)\
		.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "global_position", end_1.global_position, time)\
		.set_ease(Tween.EASE_OUT)
