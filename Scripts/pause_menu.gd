extends Control


func _on_resume_button_pressed():
	get_node("Panel").hide()


func _on_retry_button_pressed():
	pass # Replace with function body.


func _on_guide_button_pressed():
	get_node("GuideBook").show()


func _on_settings_button_pressed():
	pass # Replace with function body.


func _on_stage_button_pressed():
	get_tree().change_scene_to_file("res://stage_select.tscn")


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_close_pressed():
	get_node("GuideBook").hide()
