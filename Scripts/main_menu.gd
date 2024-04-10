extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://stage_select.tscn")


func _on_guide_book_pressed():
	get_node("GuideBook").show()


func _on_settings_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()


func _on_close_pressed():
	get_node("GuideBook").hide()
