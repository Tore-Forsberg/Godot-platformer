class_name MainMenu extends Control


func _on_play_button_pressed():
	LevelManager.load_level(1)
	deactivate()


func _on_quit_button_pressed():
	get_tree().quit()


func deactivate() -> void:
	hide()
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)
