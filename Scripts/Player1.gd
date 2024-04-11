extends Node3D

@onready var blue_skill = preload("res://Particles/blue_orb.tscn")
@onready var blue_spawn_point = get_node("../CameraNode/BlueSpawn")
@onready var red_skill = preload("res://Particles/red_orb.tscn")
@onready var red_spawn_point = get_node("../CameraNode/RedSpawn")
@onready var infinity_skill = preload("res://Particles/infinity_orb.tscn")
@onready var infinity_spawn_point = get_node("../CameraNode/InfinitySpawn")
@onready var purple_skill = preload("res://Particles/purple_orb.tscn")
@onready var purple_spawn_point = get_node("../CameraNode/PurpleSpawn")

@onready var enemy_health = get_node("../Enemy/VBoxContainer/ProgressBar")
@onready var enemy_block = get_node("../Enemy")

var current_health = 150
var max_health = 150

enum {Q, W, E, R}
var timer:Timer
var Sequence:Array = []
var Moves:Dictionary = {
	"Blue" : [Q, R, W, E],
	"Red" : [W, E, Q, R],
	"Infinity" : [E, W, R, Q],
	"Purple" : [R, Q, E, W]
	}
var Names:Array = Moves.keys()

var defend = false

func _ready():
	get_node("../Player/AnimationPlayer").play("Idle")
	set_health($VBoxContainer/ProgressBar, current_health, max_health)
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 5
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "on_timeout"))
	$Label.text = str(Sequence)

func _input(event):
	if not event is InputEventKey: #for particular example limit to keyboard
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
	timer.start() #reset timeout timer
	check_sequence()
	
#	if event.is_action_pressed("Skill1"):
#		get_node("../Player/AnimationPlayer").play("Blue")
#		await get_tree().create_timer(1.25).timeout
#		spawn_blue()
#		await get_node("../Player/AnimationPlayer").animation_finished
#		get_node("../Player/AnimationPlayer").play("Idle")
#
#	elif event.is_action_pressed("Skill2"):
#		get_node("../Player/AnimationPlayer").play("Red")
#		spawn_red()
#		await get_node("../Player/AnimationPlayer").animation_finished
#		get_node("../Player/AnimationPlayer").play("Idle")
#
#	elif event.is_action_pressed("Block"):
#		get_node("../Player/AnimationPlayer").play("InfinityS")
#		spawn_infinity()
#		await get_node("../Player/AnimationPlayer").animation_finished
#		get_node("../Player/AnimationPlayer").play("Infinity")
#		await get_node("../Player/AnimationPlayer").animation_finished
#		get_node("../Player/AnimationPlayer").play("InfinityE")
#		await get_node("../Player/AnimationPlayer").animation_finished
#		get_node("../Player/AnimationPlayer").play("Idle")
#
#	elif event.is_action_pressed("Ultimate"):
#		get_node("../Player/AnimationPlayer").play("Purple")
#		await get_tree().create_timer(2.22).timeout
#		spawn_purple()
#		await get_node("../Player/AnimationPlayer").animation_finished
#		get_node("../Player/AnimationPlayer").play("Idle")

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
			if Name == "Blue":
				get_node("../Player/AnimationPlayer").play("Blue")
				await get_tree().create_timer(1.25).timeout
				spawn_blue()
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Idle")
			elif Name == "Red":
				get_node("../Player/AnimationPlayer").play("Red")
				spawn_red()
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Idle")
			elif Name == "Infinity":
				get_node("../Player/AnimationPlayer").play("InfinityS")
				spawn_infinity()
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Infinity")
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("InfinityE")
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Idle")
			elif Name == "Purple":
				get_node("../Player/AnimationPlayer").play("Purple")
				await get_tree().create_timer(2.22).timeout
				spawn_purple()
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Idle")
			Sequence = []
			$Label.text = Name
			return

func spawn_blue():
	var blue_spd = 10
	var blue_dmg = 10
	var blue_orb = blue_skill.instantiate()
	
	add_sibling(blue_orb)
	
	blue_orb.transform = blue_spawn_point.global_transform
	blue_orb.linear_velocity = blue_spawn_point.global_transform.basis.z  * blue_spd
	
	deal_dmg(blue_dmg)
	

func spawn_red():
	var red_spd = 50
	var red_dmg = 15
	var red_orb = red_skill.instantiate()
	
	add_sibling(red_orb)
	
	red_orb.transform = red_spawn_point.global_transform
	red_orb.linear_velocity = red_spawn_point.global_transform.basis.z  * red_spd
	
	deal_dmg(red_dmg)

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
	
	deal_dmg(purp_dmg)

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
	
