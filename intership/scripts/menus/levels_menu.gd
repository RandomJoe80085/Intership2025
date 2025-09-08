extends Control


func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/tutorial_level.tscn")


func _on_level_1_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")
