extends Area2D

@onready var game_manager: Node = %GameManager
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D 

var is_collected: bool = false

func _on_body_entered(body: Node2D) -> void:
	if is_collected: return
	is_collected = true
	
	game_manager.add_point()
	
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(self, "position:y", position.y - 60, 0.45).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	
	tween.tween_property(sprite, "scale", Vector2(1.8, 0.2), 0.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(sprite, "rotation_degrees", 360.0 * 2, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

	await tween.finished
	queue_free()
