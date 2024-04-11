extends Node3D

@onready var player_health = get_node("../Player/VBoxContainer/ProgressBar")
@onready var player_block = get_node("../Player")
@onready var player = get_node("../Player")

var current_health = 100
var max_health = 100

var defend = true
var turn = false

signal nextQueue

func _ready():
	get_node("AnimationPlayer").play("Idle")
	set_health($VBoxContainer/ProgressBar, current_health, max_health)
	
	emit_signal("nextQueue")

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health


func _on_player_next_turn():
	await get_tree().create_timer(5).timeout
	pass
	turn = false
	player.turn = true
	get_node("../TurnLabel").text = "Your turn"
	emit_signal("nextQueue")
