extends Area2D

@export var SPEED = 1000
#@export var RANGE = 2000

#var traveled_distance = 0

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	#traveled_distance += SPEED * delta
	#if traveled_distance > RANGE:
		#queue_free()


func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
