extends Node

var score = 0 
@onready var score_label: Label = $ScoreLabel
@onready var control: Control = $"../CanvasLayer/Control"
@onready var player: CharacterBody2D = $"../Player"
@onready var health_bar: Label = $HealthBar



func _ready() -> void:
	updateHealthBar()

func add_point():
	score +=1 
	print(score)
	score_label.text = "Vous avez récupéré " + str(score) + " coins !"
	control.updateCoins(score)

func updateHealthBar():
	var health = player.get_node("HealthComponent")
	health_bar.text = health.getHealth()
	
	
	
