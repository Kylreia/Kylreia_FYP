extends Node3D

@onready var blast_skill = preload("res://Particles/blast_orb.tscn")
@onready var blast_spawn_point = get_node("../CameraNode/BlastSpawn")

@onready var player_health = get_node("../Player/VBoxContainer/ProgressBar")

var current_health = 100
var max_health = 100

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
#		get_node("../Enemy/AnimationPlayer").play("Blast")
#		await get_tree().create_timer(1.3).timeout
#		spawn_blast()
#		await get_node("../Enemy/AnimationPlayer").animation_finished
#		get_node("../Enemy/AnimationPlayer").play("Idle")

func spawn_blast():
	var blast_spd = 10
	var blast_dmg = 10
	var blast_orb = blast_skill.instantiate()
	
	add_sibling(blast_orb)
	
	blast_orb.transform = blast_spawn_point.global_transform
	blast_orb.linear_velocity = blast_spawn_point.global_transform.basis.z * -blast_spd
	
	deal_dmg(blast_dmg)
