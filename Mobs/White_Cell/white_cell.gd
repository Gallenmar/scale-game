extends CharacterBody2D

@export var speed = 400
var active = false
var health = 40
var timer = 1

#crush
var player_near = true
var hovered = false
signal dead(pos:Vector2)
signal crush(pos)
#end crush

func _ready():
	#crush
	$Sprite2D/LowHealth.hide()
	$Sprite2D/Border.hide()

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
	#crush
	if hovered and health <=10 and player_near:
		$Sprite2D/Border.show()
	else:
		$Sprite2D/Border.hide()
	#end crush

func _on_area_2d_body_entered(_body):
	active = true

func take_damage():
	health -= 10
	if health<=10:
			$"Sprite2D/LowHealth/Low Health Flickering".start()
	if health<=0:
		dead.emit(global_position)
		queue_free()

func jump_away(dir):
	var tween = get_tree().create_tween()
	tween.tween_property($".", "global_position", global_position+ dir*200 ,0.2)

func _on_hover_area_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("dash") and $Sprite2D/Border.visible:
		crush.emit(global_position)
		queue_free()
		dead.emit(global_position)

func _on_hover_area_mouse_entered():
	hovered = true

func _on_hover_area_mouse_exited():
	hovered = false

func _on_crush_distance_body_entered(body):
	player_near = true

func _on_crush_distance_body_exited(body):
	player_near = false

func _on_low_health_flickering_timeout():
	if timer == 1:
		$Sprite2D/LowHealth.show()
		timer = 2
	else:
		$Sprite2D/LowHealth.hide()
		timer = 1

