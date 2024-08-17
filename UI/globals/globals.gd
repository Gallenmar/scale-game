extends Node

signal health_change

var health = 100:
	get:
		return health
	set(value):
		health = value
		health_change.emit()

var player_pos :Vector2
