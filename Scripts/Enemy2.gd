extends Node3D

@onready var voidblast_skill = preload("res://Particles/void_orb.tscn")
@onready var voidblast_spawn_point = get_node("../CameraNode/VoidBlastSpawn")
@onready var barrier_skill = preload("res://Particles/barrier.tscn")
@onready var barrier_spawn_point = get_node("../CameraNode/BarrierSpawn")
@onready var rupture_skill = preload("res://Particles/rupture.tscn")
@onready var rupture_spawn_point = get_node("../CameraNode/RuptureSpawn")

@onready var player_health = get_node("../Player/VBoxContainer/ProgressBar")

var current_health = 150
var max_health = 150

func _ready():
	get_node("AnimationPlayer").play("Idle")
	set_health($VBoxContainer/ProgressBar, current_health, max_health)

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health

func deal_dmg(value):
	player_health.value -= value

# FOR TESTING
#func _input(event):
#	if event.is_action_pressed("Skill1"):
#		get_node("../Enemy/AnimationPlayer").play("Rupture")
#		await get_tree().create_timer(1.4).timeout
#		spawn_rupture()
#		await get_node("../Enemy/AnimationPlayer").animation_finished
#		get_node("../Enemy/AnimationPlayer").play("Idle")
#
#	elif event.is_action_pressed("Skill2"):
#		get_node("../Enemy/AnimationPlayer").play("Blast")
#		await get_tree().create_timer(1).timeout
#		for n in 5:
#			spawn_voidblast()
#			await get_tree().create_timer(0.3).timeout
#		# end for
#		await get_node("../Enemy/AnimationPlayer").animation_finished
#		get_node("../Enemy/AnimationPlayer").play("Idle")
#
#	elif event.is_action_pressed("Block"):
#		get_node("../Enemy/AnimationPlayer").play("Barrier")
#		await get_tree().create_timer(1.7).timeout
#		spawn_barrier()
#		await get_node("../Enemy/AnimationPlayer").animation_finished
#		get_node("../Enemy/AnimationPlayer").play("Idle")
#
func spawn_voidblast():
	var voidblast_spd = 10
	var voidblast_dmg = 15
	var voidblast_orb = voidblast_skill.instantiate()
	
	add_sibling(voidblast_orb)
	
	voidblast_orb.transform = voidblast_spawn_point.global_transform
	voidblast_orb.linear_velocity = voidblast_spawn_point.global_transform.basis.z * -voidblast_spd
	
	deal_dmg(voidblast_dmg)

func spawn_barrier():
	var barrier_orb = barrier_skill.instantiate()
	
	add_sibling(barrier_orb)
	
	barrier_orb.transform = barrier_spawn_point.global_transform
	
	await get_tree().create_timer(3.4).timeout
	
	barrier_orb.queue_free()


func spawn_rupture():
	var rupture_orb = rupture_skill.instantiate()
	var rupture_dmg = 15
	add_sibling(rupture_orb)
	
	rupture_orb.transform = rupture_spawn_point.global_transform
	
	await get_tree().create_timer(1.5).timeout
	
	rupture_orb.queue_free()
	
	deal_dmg(rupture_dmg)

