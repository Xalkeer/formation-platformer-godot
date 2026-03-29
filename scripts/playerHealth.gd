extends Node

var current_health = 3
var max_health = 3

signal health_changed(new_health: int)

	
func getHealth():
	return current_health
	

func reducHealth(amount):
	current_health -= amount
	current_health = max(0, current_health) 
	health_changed.emit(current_health)
