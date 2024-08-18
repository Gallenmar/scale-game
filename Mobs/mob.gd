extends CharacterBody2D

signal dead(pos:Vector2)

@onready var player = get_node("/root/World/Player")
var health :int = 30

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300
	move_and_slide()
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var body := collision.get_collider()
		if body.name == "Player":
			print(body)
			body.take_damage()

func take_damage():
	health -= 25
	if health<=0:
		dead.emit(global_position)
		queue_free()
