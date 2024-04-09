extends Node3D

@onready var slash_skill = preload("res://Particles/blue_orb.tscn")
# @onready var slashn_skill = preload("res://Particles/blue_slash.tscn")
@onready var slash_spawn_point = get_node("../CameraNode/SlashSpawn")
@onready var laser_skill = preload("res://Particles/orange_laser.tscn")
# @onready var lasern_skill = preload("res://Particles/blue_laser.tscn")
@onready var laser_spawn_point = get_node("../CameraNode/LaserSpawn")
@onready var laser2_spawn_point = get_node("../CameraNode/LaserSpawn2")
@onready var steam_skill = preload("res://Particles/purple_orb.tscn")
@onready var steam_spawn_point = get_node("../CameraNode/SteamSpawn")

func _ready():
	get_node("../Player/AnimationPlayer").play("Idle")

func _input(event):
	if event.is_action_pressed("Skill1"):
		get_node("../Player/AnimationPlayer").play("Slashes")
		await get_tree().create_timer(1.35).timeout
		spawn_slash()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")
	
	elif event.is_action_pressed("Skill2"):
		get_node("../Player/AnimationPlayer").play("Laser")
		await get_tree().create_timer(1.4).timeout
		spawn_laser()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")
	
	elif event.is_action_pressed("Block"):
		get_node("../Player/AnimationPlayer").play("Overheat")
		# spawn_steam()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")
	
	elif event.is_action_pressed("Ultimate"):
		get_node("../Player/AnimationPlayer").play("Slashes")
		await get_tree().create_timer(1.35).timeout
		spawn_slashb()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Laser")
		await get_tree().create_timer(1.4).timeout
		spawn_laserb()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")

func spawn_slash():
	var slash_spd = 10
	var slash_orb = slash_skill.instantiate()
	
	add_sibling(slash_orb)
	
	slash_orb.transform = slash_spawn_point.global_transform
	slash_orb.linear_velocity = slash_spawn_point.global_transform.basis.z  * slash_spd

func spawn_laser():
	var laser_spd = 30
	var laser_orb = laser_skill.instantiate()
	var laser2_orb = laser_skill.instantiate()
	
	add_sibling(laser_orb)
	add_sibling(laser2_orb)
	
	laser_orb.transform = laser_spawn_point.global_transform
	laser_orb.linear_velocity = laser_spawn_point.global_transform.basis.z  * laser_spd	
	laser2_orb.transform = laser2_spawn_point.global_transform
	laser2_orb.linear_velocity = laser2_spawn_point.global_transform.basis.z  * laser_spd	

func spawn_slashb():
	var slash_spd = 10
	var slash_orb = slash_skill.instantiate()
	
	add_sibling(slash_orb)
	
	slash_orb.transform = slash_spawn_point.global_transform
	slash_orb.linear_velocity = slash_spawn_point.global_transform.basis.z  * slash_spd

func spawn_laserb():
	var laser_spd = 50
	var laser_orb = laser_skill.instantiate()
	var laser2_orb = laser_skill.instantiate()
	
	add_sibling(laser_orb)
	add_sibling(laser2_orb)
	
	laser_orb.transform = laser_spawn_point.global_transform
	laser_orb.linear_velocity = laser_spawn_point.global_transform.basis.z  * laser_spd	
	laser2_orb.transform = laser2_spawn_point.global_transform
	laser2_orb.linear_velocity = laser2_spawn_point.global_transform.basis.z  * laser_spd	

func spawn_steam():
	var steam_spd = 25
	var steam_orb = steam_skill.instantiate()
	
	add_sibling(steam_orb)
	
	steam_orb.transform = steam_spawn_point.global_transform
	steam_orb.linear_velocity = steam_spawn_point.global_transform.basis.z  * steam_spd
	


