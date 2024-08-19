extends Area2D

var rotation_speed = 4

func _ready():
	$Timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += rotation_speed * delta


func _on_body_entered(_body):
	Globals.health += 30
	queue_free()


func _on_timer_timeout():
	queue_free()
