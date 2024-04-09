extends Node3D

@onready var shard_skill = preload("res://Particles/shard.tscn")
@onready var shard_spawn_point = get_node("../CameraNode/ShardSpawn")
@onready var whip_skill = preload("res://Particles/whip.tscn")
@onready var whip_spawn_point = get_node("../CameraNode/WhipSpawn")
@onready var whip2_spawn_point = get_node("../CameraNode/WhipSpawn2")
@onready var wall_skill = preload("res://Particles/wall.tscn")
@onready var wall_spawn_point = get_node("../CameraNode/WallSpawn")
@onready var wall2_spawn_point = get_node("../CameraNode/WallSpawn2")
@onready var wave_skill = preload("res://Particles/wave.tscn")
@onready var wave_spawn_point = get_node("../CameraNode/WaveSpawn")
@onready var wave2_spawn_point = get_node("../CameraNode/WaveSpawn2")

func _ready():
	get_node("AnimationPlayer").play("Idle")

# FOR TESTING
func _input(event):
	if event.is_action_pressed("Skill1"):
		get_node("../Enemy/AnimationPlayer").play("Shard")
		await get_tree().create_timer(1.4).timeout
		spawn_shard()
		await get_node("../Enemy/AnimationPlayer").animation_finished
		get_node("../Enemy/AnimationPlayer").play("Whip")
	
	elif event.is_action_pressed("Skill2"):
		get_node("../Enemy/AnimationPlayer").play("Blast")
		await get_tree().create_timer(1).timeout
		for n in 5:
			spawn_whip()
			await get_tree().create_timer(0.3).timeout
		# end for
		await get_node("../Enemy/AnimationPlayer").animation_finished
		get_node("../Enemy/AnimationPlayer").play("Idle")
	
	elif event.is_action_pressed("Block"):
		get_node("../Enemy/AnimationPlayer").play("Wall")
		await get_tree().create_timer(1.7).timeout
		spawn_wall()
		await get_node("../Enemy/AnimationPlayer").animation_finished
		get_node("../Enemy/AnimationPlayer").play("Idle")
		
	elif event.is_action_pressed("Ultimate"):
		get_node("../Enemy/AnimationPlayer").play("Wave")
		await get_tree().create_timer(0.1).timeout
		spawn_wave()
		await get_node("../Enemy/AnimationPlayer").animation_finished
		get_node("../Enemy/AnimationPlayer").play("Idle")

func spawn_shard():
	var shard_spd = 10
	var shard_orb = shard_skill.instantiate()
	
	add_sibling(shard_orb)
	
	shard_orb.transform = shard_spawn_point.global_transform
	shard_orb.linear_velocity = shard_spawn_point.global_transform.basis.z * shard_spd

func spawn_whip():
	var whip_orb = whip_skill.instantiate()
	
	add_sibling(whip_orb)
	
	whip_orb.transform = whip_spawn_point.global_transform
	
	await get_tree().create_timer(3.4).timeout
	
	whip_orb.queue_free()
	

func spawn_wall():
	var wall_orb = wall_skill.instantiate()
	var wall_orb2 = wall_skill.instantiate()
	
	add_sibling(wall_orb)
	add_sibling(wall_orb2)
	
	wall_orb.transform = wall_spawn_point.global_transform
	wall_orb2.transform = wall2_spawn_point.global_transform
	
	await get_tree().create_timer(1.5).timeout
	
	wall_orb.queue_free()

func spawn_wave():
	var wave_orb = wave_skill.instantiate()
	var wave_orb2 = wave_skill.instantiate()
	
	add_sibling(wave_orb)
	add_sibling(wave_orb2)
	
	wave_orb.transform = wave_spawn_point.global_transform
	wave_orb2.transform = wave2_spawn_point.global_transform
	
	await get_tree().create_timer(1.5).timeout
	
	wave_orb.queue_free()
