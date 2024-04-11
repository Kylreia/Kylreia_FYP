extends Node3D

@onready var blue_skill = preload("res://Particles/blue_orb.tscn")
@onready var blue_spawn_point = get_node("../CameraNode/BlueSpawn")
@onready var red_skill = preload("res://Particles/red_orb.tscn")
@onready var red_spawn_point = get_node("../CameraNode/RedSpawn")
@onready var infinity_skill = preload("res://Particles/infinity_orb.tscn")
@onready var infinity_spawn_point = get_node("../CameraNode/InfinitySpawn")
@onready var purple_skill = preload("res://Particles/purple_orb.tscn")
@onready var purple_spawn_point = get_node("../CameraNode/PurpleSpawn")

var current_health = 150
var max_health = 150

func _ready():
	get_node("../Player/AnimationPlayer").play("Idle")
	set_health($VBoxContainer/ProgressBar, current_health, max_health)

func _input(event):
	if event.is_action_pressed("Skill1"):
		get_node("../Player/AnimationPlayer").play("Blue")
		await get_tree().create_timer(1.25).timeout
		spawn_blue()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")
	
	elif event.is_action_pressed("Skill2"):
		get_node("../Player/AnimationPlayer").play("Red")
		spawn_red()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")
	
	elif event.is_action_pressed("Block"):
		get_node("../Player/AnimationPlayer").play("InfinityS")
		spawn_infinity()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Infinity")
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("InfinityE")
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")
	
	elif event.is_action_pressed("Ultimate"):
		get_node("../Player/AnimationPlayer").play("Purple")
		await get_tree().create_timer(2.22).timeout
		spawn_purple()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")

func spawn_blue():
	var blue_spd = 10
	var blue_dmg = 10
	var blue_orb = blue_skill.instantiate()
	
	add_sibling(blue_orb)
	
	blue_orb.transform = blue_spawn_point.global_transform
	blue_orb.linear_velocity = blue_spawn_point.global_transform.basis.z  * blue_spd

func spawn_red():
	var red_spd = 50
	var red_dmg = 15
	var red_orb = red_skill.instantiate()
	
	add_sibling(red_orb)
	
	red_orb.transform = red_spawn_point.global_transform
	red_orb.linear_velocity = red_spawn_point.global_transform.basis.z  * red_spd
	
func spawn_infinity():
	var infinity_orb = infinity_skill.instantiate()
	
	add_sibling(infinity_orb)
	
	infinity_orb.transform = infinity_spawn_point.global_transform
	
	await get_tree().create_timer(3.5).timeout
	
	infinity_orb.queue_free()

func spawn_purple():
	var purp_spd = 25
	var purp_dmg = 25
	var purp_orb = purple_skill.instantiate()
	
	add_sibling(purp_orb)
	
	purp_orb.transform = purple_spawn_point.global_transform
	purp_orb.linear_velocity = purple_spawn_point.global_transform.basis.z  * purp_spd

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
