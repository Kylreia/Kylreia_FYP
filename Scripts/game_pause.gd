extends Node3D

func _input(event):
	if event.is_action_pressed("Pause"):
		get_node("PauseMenu/Panel").show()
