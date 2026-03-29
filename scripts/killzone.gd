extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	# 1. On vérifie si c'est bien le joueur (en cherchant son HealthComponent)
	if body.has_node("HealthComponent"):
		var healthComponent = body.get_node("HealthComponent")
		
		if healthComponent.has_method("reducHealth") and healthComponent.has_method("getHealth"):
			if healthComponent.getHealth() > 1:
				healthComponent.reducHealth(1)
			else:
				death(body)
		# 3. On le téléporte à sa dernière position sécurisée !
		if body.has_method("respawn_to_last_safe_ground"):
			body.respawn_to_last_safe_ground()
	
func death(body: Node2D):
	print("You died")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()
	


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
