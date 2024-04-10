extends Control


func _on_training_pressed():
	get_tree().change_scene_to_file("res://trainingRoom.tscn")


func _on_stage_1_pressed():
	get_tree().change_scene_to_file("res://shibuyaCrossing.tscn")


func _on_stage_2_pressed():
	get_tree().change_scene_to_file("res://dimensionCrack.tscn")


func _on_stage_3_pressed():
	get_tree().change_scene_to_file("res://demonTower.tscn")
