extends Control
class_name DeathMenu

func _ready() -> void:
	hide()

func show_death_screen():
	get_tree().paused = true
	show()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	


func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
