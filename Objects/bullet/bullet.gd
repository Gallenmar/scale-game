extends Area2D

@export var SPEED = 1000
@export var RANGE = 20000 # comment this when the walls are guarantied

var traveled_distance = 0
var player : bool= false

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	traveled_distance += SPEED * delta
	if traveled_distance > RANGE:
		queue_free()


func _on_body_entered(body):
	if !player:
		if body.has_method("take_damage") and body.name == "Player":
			queue_free()
			body.take_damage()
	else:
		queue_free()
		if body.has_method("take_damage") and body.name != "Player":
			body.take_damage()
