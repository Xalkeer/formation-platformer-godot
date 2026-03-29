extends Control

@onready var coins_display: Label = $coinsDisplay


func updateCoins(coinsnbr):
	coins_display.text = str(coinsnbr)
