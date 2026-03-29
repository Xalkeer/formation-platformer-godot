extends Node

var score = 0 
@onready var score_label: Label = $ScoreLabel
@onready var control: Control = $"../CanvasLayer/Control"
@onready var player: CharacterBody2D = $"../Player"

@onready var health_bar: Node2D = $"../CanvasLayer/HealthBar"


func add_point():
	score +=1 
	print(score)
	score_label.text = "Vous avez récupéré " + str(score) + " coins !"
	control.updateCoins(score)
	updateHealthBar()

func updateHealthBar():
	health_bar.setHealth(health_bar.getHealth()-1)
	health_bar.update_hearts()
	
	
	
