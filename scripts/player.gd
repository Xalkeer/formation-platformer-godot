extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var last_safe_position: Vector2 = Vector2.ZERO
@onready var health_bar: Node2D = $"../CanvasLayer/HealthBar"
@onready var player: CharacterBody2D = $"."

@export var tilemap_A: TileMap
@export var tilemap_B: TileMap
@onready var swap_environment: Node = $SwapEnvironment

func _ready():
	last_safe_position = global_position
	swap_environment.setTilemapAB(tilemap_A,tilemap_B)
	
	if player.has_node("HealthComponent"):
		var health_comp = player.get_node("HealthComponent")
		health_comp.health_changed.connect(health_bar._on_player_health_changed)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction : -1, 0, 1 
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
		
	# Play Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else: 
			animated_sprite_2d.play("run")
	else: 
		animated_sprite_2d.play("jump")
	# Apply movement 
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_on_floor():
		# On enregistre sa position globale actuelle
		last_safe_position = global_position

	move_and_slide()
	
func respawn_to_last_safe_ground():
	global_position = last_safe_position
	# Optionnel : Tu peux remettre sa vitesse à zéro pour éviter qu'il garde son élan de chute
	velocity = Vector2.ZERO
