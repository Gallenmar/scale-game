extends CharacterBody2D

@onready var player = get_node("/root/World/Player")
var health :int = 100

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300
	move_and_slide()

func take_damage():
	health -= 25
	if health<=0:
		queue_free()
