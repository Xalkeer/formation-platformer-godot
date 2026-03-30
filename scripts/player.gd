extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: Node2D = $"../CanvasLayer/HealthBar"
@onready var player: CharacterBody2D = $"."
@onready var swap_environment: Node = $SwapEnvironment
# --- AJOUT DU NOEUD DE PARTICULES ---
@onready var run_particles: GPUParticles2D = $RunParticles 

@export var tilemap_A: TileMap
@export var tilemap_B: TileMap

var last_safe_position: Vector2 = Vector2.ZERO

func _ready():
	last_safe_position = global_position
	swap_environment.setTilemapAB(tilemap_A, tilemap_B)
	
	if player.has_node("HealthComponent"):
		var health_comp = player.get_node("HealthComponent")
		health_comp.health_changed.connect(health_bar._on_player_health_changed)

func _physics_process(delta: float) -> void:
	# Gravité
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Saut
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		# Petit burst de poussière au moment de l'impulsion
		spawn_dust_burst()

	# Direction
	var direction := Input.get_axis("move_left", "move_right")
	
	# Gestion du Sprite et des Particules
	if direction != 0:
		animated_sprite_2d.flip_h = (direction < 0)
		# On oriente les particules à l'opposé de la marche
		run_particles.process_material.direction.x = -direction
	
	# Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else: 
			animated_sprite_2d.play("run")
	else: 
		animated_sprite_2d.play("jump")
		
	# Application du mouvement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Enregistrement de la position de sécurité
	if is_on_floor():
		last_safe_position = global_position
		
	move_and_slide()
	
	# --- MISE À JOUR DES PARTICULES DE COURSE ---
	update_run_particles(direction)

func update_run_particles(direction: float):
	# On n'émet que si on est au sol et qu'on court vraiment
	if is_on_floor() and direction != 0:
		run_particles.emitting = true
	else:
		run_particles.emitting = false

func spawn_dust_burst():
	# Relance un cycle complet de particules instantanément pour le saut
	run_particles.restart()
	run_particles.emitting = true

func respawn_to_last_safe_ground():
	global_position = last_safe_position
	velocity = Vector2.ZERO
