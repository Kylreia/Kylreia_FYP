extends Node3D

@onready var swipe_skill = preload("res://Particles/swipe.tscn")
@onready var swipe_spawn_point = get_node("../CameraNode/SwipeSpawn")
@onready var lightning_skill = preload("res://Particles/lightning.tscn")
@onready var lightning_spawn_point = get_node("../CameraNode/LightningSpawn")
@onready var cloak_skill = preload("res://Particles/cloak.tscn")
@onready var cloak_spawn_point = get_node("../CameraNode/CloakSpawn")
@onready var fragment_skill = preload("res://Particles/fragment.tscn")
@onready var fragment_spawn_point = get_node("../CameraNode/FragmentSpawn")

var current_health = 150
var max_health = 150

func _ready():
	get_node("../Player/AnimationPlayer").play("Idle")
	set_health($VBoxContainer/ProgressBar, current_health, max_health)

func _input(event):
	if event.is_action_pressed("Skill1"):
		get_node("../Player/AnimationPlayer").play("Rush")
		await get_tree().create_timer(1).timeout
		spawn_swipe()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")
	
	elif event.is_action_pressed("Skill2"):
		get_node("../Player/AnimationPlayer").play("Lightning")
		await get_tree().create_timer(2.4).timeout
		for n in 3:
			spawn_lightning()
			await get_tree().create_timer(0.2).timeout
		# end for
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")
	
	elif event.is_action_pressed("Block"):
		get_node("../Player/AnimationPlayer").play("Cloak")
		await get_tree().create_timer(1.1).timeout
		spawn_cloak()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")
	
	elif event.is_action_pressed("Ultimate"):
		get_node("../Player/AnimationPlayer").play("Fragment")
		await get_tree().create_timer(0.1).timeout
		spawn_fragment()
		await get_node("../Player/AnimationPlayer").animation_finished
		get_node("../Player/AnimationPlayer").play("Idle")

func spawn_swipe():
	var swipe_dmg = 10
	var swipe_orb = swipe_skill.instantiate()

	add_sibling(swipe_orb)

	swipe_orb.transform = swipe_spawn_point.global_transform
	
	await get_tree().create_timer(3).timeout
	
	swipe_orb.queue_free()

func spawn_lightning():
	var lightning_spd = 30
	var lightning_dmg = 20
	var lightning_orb = lightning_skill.instantiate()
	
	add_sibling(lightning_orb)
	
	lightning_orb.transform = lightning_spawn_point.global_transform
	lightning_orb.linear_velocity = lightning_spawn_point.global_transform.basis.y * -lightning_spd

func spawn_cloak():
	var cloak_orb = cloak_skill.instantiate()
	
	add_sibling(cloak_orb)
	
	cloak_orb.transform = cloak_spawn_point.global_transform
	
	await get_tree().create_timer(5.6).timeout
	
	cloak_orb.queue_free()

func spawn_fragment():
	var fragment_spd = 30
	var fragment_dmg = 30
	var fragment_orb = fragment_skill.instantiate()
	
	add_sibling(fragment_orb)
	
	fragment_orb.transform = fragment_spawn_point.global_transform
	fragment_orb.linear_velocity = fragment_spawn_point.global_transform.basis.z * fragment_spd

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
