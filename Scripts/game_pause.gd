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


# Turn Queue System

#var active_char
#
#func initialize():
#	active_char = get_child(0)
#
#func play_turn():
#	await active_char.play_turn()
#	var new_index : int = (active_char.get_index() + 1) % get_child_count()

var current_health = 76
var max_health = 150
