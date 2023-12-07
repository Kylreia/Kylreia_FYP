extends Node3D

func _ready():
	get_node("../AnimationPlayer").play("Idle")

func _input(event):
	if event.is_action_pressed("Skill1"):
		get_node("../AnimationPlayer").play("Blue")
		await get_node("../AnimationPlayer").animation_finished
		get_node("../AnimationPlayer").play("Idle")
	elif event.is_action_pressed("Skill2"):
		rotate_object_local(Vector3.FORWARD, -90.0)
		get_node("../AnimationPlayer").play("Red")
		await get_node("../AnimationPlayer").animation_finished
		rotate_object_local(Vector3.FORWARD, 90.0)
		get_node("../AnimationPlayer").play("Idle")
	elif event.is_action_pressed("Block"):
		get_node("../AnimationPlayer").play("Infinity")
		await get_node("../AnimationPlayer").animation_finished
		get_node("../AnimationPlayer").play("Idle")
	elif event.is_action_pressed("Ultimate"):
		get_node("../AnimationPlayer").play("Purple")
		await get_node("../AnimationPlayer").animation_finished
		get_node("../AnimationPlayer").play("Idle")

# To do:
# Smoother transition from action animation to idle animation
# Lock player out of sending inputs while an animation is playing
# Loop idle animation for when the player has not pressed any key for a while
