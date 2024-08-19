extends Node

signal health_change
signal vulnurability_change

var is_vulnurable :bool = true:
	get:
		return is_vulnurable
	set(value):
		if (!value):
			vulnurability_change.emit()
		is_vulnurable=value

var health = 100:
	get:
		return health
	set(value):
		health = min(value, 100)
		health_change.emit()

var player_pos :Vector2
