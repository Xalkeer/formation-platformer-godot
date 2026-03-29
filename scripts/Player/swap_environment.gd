extends Node

@onready var player: CharacterBody2D = $".."

var dans_dimension_B: bool = false

var tilemap_A: TileMap
var tilemap_B: TileMap

func setTilemapAB(tilemapA, tilemapB):
	tilemap_A = tilemapA
	tilemap_B = tilemapB
	print(tilemap_A)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("swapDimension"):
		swapEnvironment()

func swapEnvironment() -> void:
	dans_dimension_B = !dans_dimension_B
	
	if dans_dimension_B:
		# --- DIMENSION B ---
		# 1. Où j'existe
		player.set_collision_layer_value(1, false)
		player.set_collision_layer_value(3, true)
		
		# 2. Ce que je touche (Pour toucher la TileMap sur la couche 3 !)
		player.set_collision_mask_value(1, false)
		player.set_collision_mask_value(3, true)
		tilemap_A.modulate = Color(1, 1, 1, 0.3)
		tilemap_B.modulate = Color(1, 1, 1, 1.0)
		
		print("Passage à la dimension B")
	else:
		# --- DIMENSION A ---
		# 1. Où j'existe
		player.set_collision_layer_value(3, false)
		player.set_collision_layer_value(1, true)
		
		# 2. Ce que je touche
		player.set_collision_mask_value(3, false)
		player.set_collision_mask_value(1, true)
		tilemap_A.modulate = Color(1, 1, 1, 1.0)
		tilemap_B.modulate = Color(1, 1, 1, 0.3)
		
		print("Retour à la dimension A")
