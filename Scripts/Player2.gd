extends Node3D

@onready var slash_skill = preload("res://Particles/orange_slash.tscn")
@onready var slashb_skill = preload("res://Particles/blue_slash.tscn")
@onready var slash_spawn_point = get_node("../CameraNode/SlashSpawn")
@onready var laser_skill = preload("res://Particles/orange_laser.tscn")
@onready var laserb_skill = preload("res://Particles/blue_laser.tscn")
@onready var laser_spawn_point = get_node("../CameraNode/LaserSpawn")
@onready var laser2_spawn_point = get_node("../CameraNode/LaserSpawn2")
@onready var steam_skill = preload("res://Particles/steam.tscn")
@onready var steam_spawn_point = get_node("../CameraNode/SteamSpawn")

@onready var enemy_health = get_node("../Enemy/VBoxContainer/ProgressBar")
@onready var enemy_block = get_node("../Enemy")
@onready var enemy = get_node("../Enemy")

var current_health = 150
var max_health = 150

signal nextTurn

enum {Q, W, E, R}
var timer:Timer
var Sequence:Array = []
var Moves:Dictionary = {
	"HeatBlades" : [W, Q, R, E],
	"LaserBeams" : [E, R, W, Q],
	"Overheat" : [R, E, Q, W],
	"TheBurner" : [Q, W, E, R]
	}
var Names:Array = Moves.keys()

var defend = false
var turn = true

func _ready():
	get_node("../Player/AnimationPlayer").play("Idle")
	set_health($VBoxContainer/ProgressBar, current_health, max_health)
	
	defend = false
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "on_timeout"))
	$Label.text = str(Sequence)
	await get_tree().create_timer(5).timeout
	turn = false
	enemy.turn = true
	emit_signal("nextTurn")

func _input(event):
	if turn == true:
		if not event is InputEventKey: 
			return
		if not event.is_pressed():
			return
		if event.is_action_pressed("Skill1"):
			add_input_to_sequence(Q)
		elif event.is_action_pressed("Skill2"):
			add_input_to_sequence(W)
		elif event.is_action_pressed("Block"):
			add_input_to_sequence(E)
		elif event.is_action_pressed("Ultimate"):
			add_input_to_sequence(R)
		$Label.text = str(Sequence)
		timer.start()
		check_sequence()

func on_timeout()->void:
	print("timeout")
	if $Label.text == str(Sequence):
		$Label.text = "timeout"
	Sequence = []

func add_input_to_sequence(button:int)->void:
	Sequence.push_back(button)

func check_sequence()->void:
	for Name in Names:
		var combo:Array = Moves[Name]
		var trim: = Sequence.duplicate()
		trim.reverse()
		trim.resize(combo.size())
		trim.reverse()
		if trim == combo:
			print("COMBO: ", Name)
			if Name == "HeatBlades":
				get_node("../Player/AnimationPlayer").play("Slashes")
				await get_tree().create_timer(1.2).timeout
				spawn_slash()
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Idle")
			elif Name == "LaserBeams":
				get_node("../Player/AnimationPlayer").play("Laser")
				await get_tree().create_timer(1.4).timeout
				spawn_laser()
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Idle")
			elif Name == "Overheat":
				get_node("../Player/AnimationPlayer").play("Overheat")
				await get_tree().create_timer(1.4).timeout
				spawn_steam()
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Idle")
			elif Name == "TheBurner":
				get_node("../Player/AnimationPlayer").play("Slashes")
				await get_tree().create_timer(1.2).timeout
				spawn_slashb()
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Laser")
				await get_tree().create_timer(1.4).timeout
				spawn_laserb()
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Idle")
			Sequence = []
			$Label.text = Name
			return

func spawn_slash():
	var slash_spd = 10
	var slash_dmg = 7.5
	var slash_orb = slash_skill.instantiate()
	
	add_sibling(slash_orb)

	slash_orb.transform = slash_spawn_point.global_transform
	
	await get_tree().create_timer(1.7).timeout
	
	slash_orb.queue_free()
	
	deal_dmg(slash_dmg)

func spawn_laser():
	var laser_spd = 30
	var laser_dmg = 15
	var laser_orb = laser_skill.instantiate()
	var laser2_orb = laser_skill.instantiate()
	
	add_sibling(laser_orb)
	add_sibling(laser2_orb)
	
	laser_orb.transform = laser_spawn_point.global_transform
	laser_orb.linear_velocity = laser_spawn_point.global_transform.basis.z  * laser_spd
	laser2_orb.transform = laser2_spawn_point.global_transform
	laser2_orb.linear_velocity = laser2_spawn_point.global_transform.basis.z  * laser_spd
	
	deal_dmg(laser_dmg)

func spawn_slashb():
	var slash_spd = 10
	var slash_dmg = 15
	var slash_orb = slashb_skill.instantiate()
	
	add_sibling(slash_orb)
	
	slash_orb.transform = slash_spawn_point.global_transform
	
	await get_tree().create_timer(1.7).timeout
	
	slash_orb.queue_free()
	
	deal_dmg(slash_dmg)

func spawn_laserb():
	var laser_spd = 50
	var laser_dmg = 30
	var laser_orb = laserb_skill.instantiate()
	var laser2_orb = laserb_skill.instantiate()
	
	add_sibling(laser_orb)
	add_sibling(laser2_orb)
	
	laser_orb.transform = laser_spawn_point.global_transform
	laser_orb.linear_velocity = laser_spawn_point.global_transform.basis.z  * laser_spd
	laser2_orb.transform = laser2_spawn_point.global_transform
	laser2_orb.linear_velocity = laser2_spawn_point.global_transform.basis.z  * laser_spd
	
	deal_dmg(laser_dmg)

func spawn_steam():
	var steam_orb = steam_skill.instantiate()
	
	add_sibling(steam_orb)
	
	steam_orb.transform = steam_spawn_point.global_transform
	
	await get_tree().create_timer(3.7).timeout
	
	steam_orb.queue_free()
	
	defend = true

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health

func deal_dmg(value):
	if enemy_block.defend == true:
		pass
	else:
		enemy_health.value -= value
	if enemy_health.value <= 0:
		get_node("../Results/Panel").show()


func _on_enemy_next_queue():
	defend = false
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "on_timeout"))
	$Label.text = str(Sequence)
	await get_tree().create_timer(7).timeout
	turn = false
	enemy.turn = true
	emit_signal("nextTurn")
