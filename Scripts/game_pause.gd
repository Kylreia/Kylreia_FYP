extends Node3D

var paused = false

func _input(event):
	if event.is_action_pressed("Pause"):
		pauseMenu(paused)

func pauseMenu(state):
	if state:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_node("PauseMenu/Panel").hide()
		get_tree().paused = false
		
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		get_node("PauseMenu/Panel").show()


func _on_resume_button_pressed():
	get_node("PauseMenu/Panel").hide()
	get_tree().paused = false


func _on_retry_button_pressed():
	pass # Replace with function body.


func _on_guide_button_pressed():
	get_node("PauseMenu/GuideBook").show()


func _on_settings_button_pressed():
	pass # Replace with function body.


func _on_stage_button_pressed():
	get_tree().change_scene_to_file("res://stage_select.tscn")
	get_tree().paused = false


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
	get_tree().paused = false


func _on_close_pressed():
	get_node("PauseMenu/GuideBook").hide()

