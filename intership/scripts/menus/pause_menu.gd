extends Control

func resume():
	get_tree().paused = false
	hide()

func pause():
	get_tree().paused = true
	show()

func restart():
	get_tree().paused = false  # Unpause before reloading
	get_tree().reload_current_scene()

func testEsc():
	if Input.is_action_just_pressed("escape") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
		resume()

func _ready() -> void:
	hide()

func _on_resume_pressed() -> void:
	resume()

func _on_restrart_pressed() -> void:
	restart()

func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false  # Also unpause when going back to menu
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _process(_delta: float) -> void:
	testEsc()
