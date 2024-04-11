extends Node3D

@onready var blast_skill = preload("res://Particles/blast_orb.tscn")
@onready var blast_spawn_point = get_node("../CameraNode/BlastSpawn")

var current_health = 50
var max_health = 100

func _ready():
	get_node("AnimationPlayer").play("Idle")

# FOR TESTING
#func _input(event):
#	if event.is_action_pressed("Skill1"):
#		get_node("../Enemy/AnimationPlayer").play("Blast")
#		await get_tree().create_timer(1.3).timeout
#		spawn_blast()
#		await get_node("../Enemy/AnimationPlayer").animation_finished
#		get_node("../Enemy/AnimationPlayer").play("Idle")
#
#func spawn_blast():
#	var blast_spd = 10
#	var blast_dmg = 10
#	var blast_orb = blast_skill.instantiate()
#
#	add_sibling(blast_orb)
#
#	blast_orb.transform = blast_spawn_point.global_transform
#	blast_orb.linear_velocity = blast_spawn_point.global_transform.basis.z * -blast_spd
