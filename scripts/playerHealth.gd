extends Node

var main_camera : Camera2D
var current_health = 3
var max_health = 3
var is_invincible : bool = false
@export var invincibility_duration : float = 1.0

signal health_changed(new_health: int)
signal player_died

func _ready():
	main_camera = get_viewport().get_camera_2d()

func getHealth():
	return current_health

func reducHealth(amount, is_void_fall: bool = false):
	if current_health <= 0 or is_invincible: 
		return
	
	current_health -= amount
	current_health = max(0, current_health) 
	health_changed.emit(current_health)
	
	if main_camera:
		main_camera.apply_shake(10.0)
		
	if current_health <= 0:
		if is_void_fall:
			print("Lancement de la mort dans le VIDE")
			die_void()
		else:
			print("Lancement de la mort CARTOON")
			die_cartoon()
	else:
		start_invincibility()

func start_invincibility():
	is_invincible = true
	var sprite = get_parent().get_node_or_null("AnimatedSprite2D")
	
	var blink_tween = create_tween().set_loops(10)
	if sprite:
		blink_tween.tween_property(sprite, "modulate:a", 0.2, 0.08)
		blink_tween.tween_property(sprite, "modulate:a", 1.0, 0.08)
	
	await get_tree().create_timer(invincibility_duration).timeout
	
	is_invincible = false
	if sprite:
		sprite.modulate.a = 1.0

# --- MORT CLASSIQUE (Ennemis, pics, etc.) ---
func die_cartoon():
	player_died.emit()
	var player = get_parent()
	is_invincible = true 
	
	player.set_physics_process(false)
	player.set_process(false)
	
	var col = player.find_child("CollisionShape2D")
	if col: col.set_deferred("disabled", true)

	var sprite = player.get_node_or_null("AnimatedSprite2D")
	var visual_tween = create_tween().set_parallel(true)
	
	if sprite:
		sprite.modulate.a = 1.0
		visual_tween.tween_property(sprite, "rotation_degrees", 720.0, 0.8).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		visual_tween.tween_property(sprite, "scale", Vector2(1.5, 0.5), 0.15)
		visual_tween.tween_property(sprite, "scale", Vector2(0.5, 2.0), 0.3).set_delay(0.15)
		visual_tween.tween_property(sprite, "modulate:a", 0.0, 0.5).set_delay(0.4)

	var move_tween = create_tween()
	var mid_y = player.position.y - 20
	var final_y = player.position.y + 800
	
	move_tween.tween_property(player, "position:y", mid_y, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	move_tween.tween_property(player, "position:y", final_y, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	await move_tween.finished
	get_tree().reload_current_scene()

# --- MORT DANS LE VIDE (Tombe tout droit en rétrécissant) ---
func die_void():
	player_died.emit()
	var player = get_parent()
	is_invincible = true 
	
	# On arrête tout mouvement
	player.set_physics_process(false)
	player.set_process(false)
	
	# Plus de collision
	var col = player.find_child("CollisionShape2D")
	if col: col.set_deferred("disabled", true)

	var sprite = player.get_node_or_null("AnimatedSprite2D")
	
	# Tween pour l'effet de profondeur (rétrécissement et transparence)
	var visual_tween = create_tween().set_parallel(true)
	if sprite:
		sprite.modulate.a = 1.0
		# Rétrécit vers le centre
		visual_tween.tween_property(sprite, "scale", Vector2.ZERO, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		# Devient transparent
		visual_tween.tween_property(sprite, "modulate:a", 0.0, 1.0)

	# Tween pour la chute accélérée
	var move_tween = create_tween()
	# Tombe très bas
	var final_y = player.position.y + 1000 
	

	move_tween.tween_property(player, "position:y", final_y, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	await move_tween.finished
	get_tree().reload_current_scene()
