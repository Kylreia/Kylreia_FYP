extends Node3D

@onready var shard_skill = preload("res://Particles/shard.tscn")
@onready var shard_spawn_point = get_node("../CameraNode/ShardSpawn")
@onready var spike_skill = preload("res://Particles/spike.tscn")
@onready var spike_spawn_point = get_node("../CameraNode/SpikeSpawn")
@onready var spike2_spawn_point = get_node("../CameraNode/SpikeSpawn2")
@onready var wall_skill = preload("res://Particles/wall.tscn")
@onready var wall_spawn_point = get_node("../CameraNode/WallSpawn")
@onready var wall2_spawn_point = get_node("../CameraNode/WallSpawn2")
@onready var wave_skill = preload("res://Particles/wave.tscn")
@onready var wave_spawn_point = get_node("../CameraNode/WaveSpawn")
@onready var wave2_spawn_point = get_node("../CameraNode/WaveSpawn2")

@onready var player_health = get_node("../Player/VBoxContainer/ProgressBar")
@onready var player_block = get_node("../Player")
@onready var player = get_node("../Player")

var current_health = 200
var max_health = 200

var defend = false
var turn = false
var rng = RandomNumberGenerator.new()

signal nextQueue

func _ready():
	get_node("AnimationPlayer").play("Idle")
	set_health($VBoxContainer/ProgressBar, current_health, max_health)

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health

func deal_dmg(value):
	if player_block.defend == true:
		pass
	else:
		player_health.value -= value
	if player_health.value <= 0:
		get_node("../Results/Panel/Label").text = "You Lost"
		get_node("../Results/Panel").show()

func spawn_shard():
	var shard_spd = 8
	var shard_dmg = 15
	var shard_orb = shard_skill.instantiate()

	add_sibling(shard_orb)

	shard_orb.transform = shard_spawn_point.global_transform
	shard_orb.linear_velocity = shard_spawn_point.global_transform.basis.z * -shard_spd
	
	deal_dmg(shard_dmg)

func spawn_spike():
	var spike_spd = 3
	var spike_dmg = 20
	var spike_orb = spike_skill.instantiate()
	var spike_orb2 = spike_skill.instantiate()

	add_sibling(spike_orb)
	add_sibling(spike_orb2)

	spike_orb.transform = spike_spawn_point.global_transform
	spike_orb2.transform = spike2_spawn_point.global_transform

	spike_orb.linear_velocity = spike_spawn_point.global_transform.basis.y * spike_spd
	spike_orb2.linear_velocity = spike2_spawn_point.global_transform.basis.y * spike_spd
	
	deal_dmg(spike_dmg)


func spawn_wall():
	var wall_spd = 10
	var wall_orb = wall_skill.instantiate()
	var wall_orb2 = wall_skill.instantiate()

	add_sibling(wall_orb)
	add_sibling(wall_orb2)

	wall_orb.transform = wall_spawn_point.global_transform
	wall_orb2.transform = wall2_spawn_point.global_transform

	wall_orb.linear_velocity = wall_spawn_point.global_transform.basis.y * wall_spd
	wall_orb2.linear_velocity = wall2_spawn_point.global_transform.basis.y * wall_spd
	
	defend = true


func spawn_wave():
	var wave_spd = 2.7
	var wave_dmg = 15
	var wave_orb = wave_skill.instantiate()
	var wave_orb2 = wave_skill.instantiate()

	add_sibling(wave_orb)
	add_sibling(wave_orb2)

	wave_orb.transform = wave_spawn_point.global_transform
	wave_orb2.transform = wave2_spawn_point.global_transform

	wave_orb.linear_velocity = wave_spawn_point.global_transform.basis.z * -wave_spd
	wave_orb2.linear_velocity = wave2_spawn_point.global_transform.basis.z * -wave_spd
	
	deal_dmg(wave_dmg)


func _on_player_next_turn():
	defend = false
	var my_num = int(rng.randf_range(1,4))
	if my_num == 1:
		get_node("../Enemy/AnimationPlayer").play("Shard")
		spawn_shard()
		await get_node("../Enemy/AnimationPlayer").animation_finished
		get_node("../Enemy/AnimationPlayer").play("Idle")
	elif my_num == 2:
		get_node("../Enemy/AnimationPlayer").play("Whip")
		await get_tree().create_timer(1.5).timeout
		spawn_spike()
		await get_node("../Enemy/AnimationPlayer").animation_finished
		get_node("../Enemy/AnimationPlayer").play("Idle")
	elif my_num == 3:
		get_node("../Enemy/AnimationPlayer").play("Wall")
		await get_tree().create_timer(0.9).timeout
		spawn_wall()
		await get_node("../Enemy/AnimationPlayer").animation_finished
		get_node("../Enemy/AnimationPlayer").play("Idle")
	elif my_num == 4:
		get_node("../Enemy/AnimationPlayer").play("Wave")
		await get_tree().create_timer(0.1).timeout
		for n in 2:
			await get_tree().create_timer(0.1).timeout
			spawn_wave()
		await get_node("../Enemy/AnimationPlayer").animation_finished
		get_node("../Enemy/AnimationPlayer").play("Idle")
	
	await get_tree().create_timer(5).timeout
	turn = false
	player.turn = true
	emit_signal("nextQueue")
