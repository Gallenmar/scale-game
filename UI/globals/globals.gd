extends Node

signal health_change

var health = 100:
	get:
		return health
	set(value):
		health = min(value, 100)
		health_change.emit()

var player_pos :Vector2
