extends Control





func _on_levels_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/levels_menu.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
