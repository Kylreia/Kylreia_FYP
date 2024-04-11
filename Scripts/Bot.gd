extends Node3D

var current_health = 100
var max_health = 100

var defend = true

func _ready():
	get_node("AnimationPlayer").play("Idle")
	set_health($VBoxContainer/ProgressBar, current_health, max_health)

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
