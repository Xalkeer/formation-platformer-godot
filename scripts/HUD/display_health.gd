extends Node2D

var hearts: Array = []
var current_health = 3

func _ready():
	hearts = [$Sprite2D, $Sprite2D2, $Sprite2D3] 
	update_hearts()

func setHealth(amount):
	current_health = amount
	
func getHealth():
	return current_health

func update_hearts():
	if hearts.is_empty(): 
		return
	for i in range(hearts.size()):
		hearts[i].visible = i < current_health
		
func _on_player_health_changed(new_health: int):
	print("test")
	setHealth(new_health)
	update_hearts()
