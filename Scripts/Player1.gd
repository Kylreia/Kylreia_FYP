extends Node3D

@onready var blue_skill = preload("res://blue_orb.tscn")
@onready var blue_spawn_point = get_node("../CameraNode/BlueSpawn")
@onready var red_skill = preload("res://red_orb.tscn")
@onready var red_spawn_point = get_node("../CameraNode/RedSpawn")
@onready var purple_skill = preload("res://purple_orb.tscn")
@onready var purple_spawn_point = get_node("../CameraNode/PurpleSpawn")

func _ready():
	get_node("../Player/AnimationPlayer").play("Idle")

func _input(event):
	if event.is_action_pressed("Skill1"):
		get_node("../Player/AnimationPlayer").play("Blue")
		await get_tree().create_timer(1.1).timeout
		spawn_blue()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")
	
	elif event.is_action_pressed("Skill2"):
		get_node("../Player/AnimationPlayer").play("Red")
		await get_tree().create_timer(1.15).timeout
		spawn_red()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")
	
	elif event.is_action_pressed("Block"):
		get_node("../Player/AnimationPlayer").play("Infinity")
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")
	
	elif event.is_action_pressed("Ultimate"):
		get_node("../Player/AnimationPlayer").play("Purple")
		await get_tree().create_timer(3.2).timeout
		spawn_purple()
		await get_node("../Player/AnimationPlayer").animation_finished
		
		get_node("../Player/AnimationPlayer").play("Idle")

func spawn_blue():
	var blue_spd = 10
	var blue_orb = blue_skill.instantiate()
	
	add_sibling(blue_orb)
	
	blue_orb.transform = blue_spawn_point.global_transform
	blue_orb.linear_velocity = blue_spawn_point.global_transform.basis.z  * blue_spd

func spawn_red():
	var red_spd = 50
	var red_orb = red_skill.instantiate()
	
	add_sibling(red_orb)
	
	red_orb.transform = red_spawn_point.global_transform
	red_orb.linear_velocity = red_spawn_point.global_transform.basis.z  * red_spd

func spawn_purple():
	var purp_spd = 25
	var purp_orb = purple_skill.instantiate()
	
	add_sibling(purp_orb)
	
	purp_orb.transform = purple_spawn_point.global_transform
	purp_orb.linear_velocity = purple_spawn_point.global_transform.basis.z  * purp_spd

# To do:
# Smoother transition from action animation to idle animation
# Lock player out of sending inputs while an animation is playing
# Loop idle animation for when the player has not pressed any key for a while
# Add trails to orbs
# Add defensive mechanics
# Keep track of a design document
# Research on grid map
