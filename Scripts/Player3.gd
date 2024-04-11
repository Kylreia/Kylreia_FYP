extends Node3D

@onready var swipe_skill = preload("res://Particles/swipe.tscn")
@onready var swipe_spawn_point = get_node("../CameraNode/SwipeSpawn")
@onready var lightning_skill = preload("res://Particles/lightning.tscn")
@onready var lightning_spawn_point = get_node("../CameraNode/LightningSpawn")
@onready var cloak_skill = preload("res://Particles/cloak.tscn")
@onready var cloak_spawn_point = get_node("../CameraNode/CloakSpawn")
@onready var fragment_skill = preload("res://Particles/fragment.tscn")
@onready var fragment_spawn_point = get_node("../CameraNode/FragmentSpawn")

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
	"Swipe" : [R, W, Q, E],
	"LightningStrike" : [Q, E, W, R],
	"LightBarrier" : [W, R, E, Q],
	"Fragment" : [E, Q, R, W]
	}
var Names:Array = Moves.keys()

var defend = false
var turn = true

func _ready():
	get_node("../Player/AnimationPlayer").play("Idle")
	set_health($VBoxContainer/ProgressBar, current_health, max_health)

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
		$ActionLabel.text = str(Sequence)
		timer.start()
		check_sequence()

func on_timeout()->void:
	print("timeout")
	if $ActionLabel.text == str(Sequence):
		$ActionLabel.text = "timeout"
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
			if Name == "Swipe":
				get_node("../Player/AnimationPlayer").play("Rush")
				await get_tree().create_timer(1).timeout
				spawn_swipe()
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Idle")
			elif Name == "LightningStrike":
				get_node("../Player/AnimationPlayer").play("Lightning")
				await get_tree().create_timer(2.4).timeout
				for n in 3:
					spawn_lightning()
					await get_tree().create_timer(0.2).timeout
				# end for
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Idle")
			elif Name == "LightBarrier":
				get_node("../Player/AnimationPlayer").play("Cloak")
				await get_tree().create_timer(1.1).timeout
				spawn_cloak()
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Idle")
			elif Name == "Fragment":
				get_node("../Player/AnimationPlayer").play("Fragment")
				await get_tree().create_timer(0.1).timeout
				spawn_fragment()
				await get_node("../Player/AnimationPlayer").animation_finished
				get_node("../Player/AnimationPlayer").play("Idle")
			Sequence = []
			$ActionLabel.text = Name
			return

func spawn_swipe():
	var swipe_dmg = 10
	var swipe_orb = swipe_skill.instantiate()
	
	add_sibling(swipe_orb)
	
	swipe_orb.transform = swipe_spawn_point.global_transform
	
	await get_tree().create_timer(3).timeout
	
	swipe_orb.queue_free()
	
	deal_dmg(swipe_dmg)

func spawn_lightning():
	var lightning_spd = 30
	var lightning_dmg = 20
	var lightning_orb = lightning_skill.instantiate()
	
	add_sibling(lightning_orb)
	
	lightning_orb.transform = lightning_spawn_point.global_transform
	lightning_orb.linear_velocity = lightning_spawn_point.global_transform.basis.y * -lightning_spd
	
	deal_dmg(lightning_dmg)

func spawn_cloak():
	var cloak_orb = cloak_skill.instantiate()
	
	add_sibling(cloak_orb)
	
	cloak_orb.transform = cloak_spawn_point.global_transform
	
	defend = true
	$BlockLabel.show()
	
	await get_tree().create_timer(5.6).timeout
	
	cloak_orb.queue_free()

func spawn_fragment():
	var fragment_spd = 30
	var fragment_dmg = 30
	var fragment_orb = fragment_skill.instantiate()
	
	add_sibling(fragment_orb)
	
	fragment_orb.transform = fragment_spawn_point.global_transform
	fragment_orb.linear_velocity = fragment_spawn_point.global_transform.basis.z * fragment_spd
	
	deal_dmg(fragment_dmg)

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
	$BlockLabel.hide()
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "on_timeout"))
	$ActionLabel.text = str(Sequence)
	await get_tree().create_timer(5).timeout
	turn = false
	enemy.turn = true
	get_node("../TurnLabel").text = "Enemy turn"
	emit_signal("nextTurn")
