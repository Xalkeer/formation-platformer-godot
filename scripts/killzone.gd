extends Area2D

@export var is_void : bool = false

func _on_body_entered(body: Node2D) -> void:
	var health_component = body.get_node_or_null("HealthComponent")
	
	if health_component:
		if health_component.is_invincible:
			return
		
		health_component.reducHealth(1, is_void)
		
		if is_void and health_component.getHealth() > 0:
			if body.has_method("respawn_to_last_safe_ground"):
				body.respawn_to_last_safe_ground()
