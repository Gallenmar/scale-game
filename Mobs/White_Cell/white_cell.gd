extends CharacterBody2D

@export var speed = 400
var active = false
var health = 40

func _process(_delta):
	if active:
		look_at(Globals.player_pos)
		var direction = (Globals.player_pos - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		for index in get_slide_collision_count():
			var collision := get_slide_collision(index)
			var body := collision.get_collider()
			if body.name == "Player":
				body.insta_kill()

func _on_area_2d_body_entered(_body):
	active = true

func take_damage():
	health -= 10
	if health<=0:
		queue_free()
