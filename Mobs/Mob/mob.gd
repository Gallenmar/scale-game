extends CharacterBody2D

signal dead(pos:Vector2)
signal crush(pos)

#@onready var player = get_node("/root/World/Player")
@export var player :Node = null
@export var speed = 300

var health :int = 30
var can_damage = true
var player_near = true
var hovered = false
var timer = 1

func _ready():
	$LowHealth.hide()
	$Border.hide()
	$"Death Animation".hide()

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	if can_damage:
		for index in get_slide_collision_count():
			var collision := get_slide_collision(index)
			var body := collision.get_collider()
			if body.name == "Player":
				body.take_damage()
				$Timer.start()
				can_damage = false
	if hovered and health <=10 and player_near:
		$Border.show()
	else:
		$Border.hide()
		

func take_damage():
	health -= 10
	if health <=10:
		$"LowHealth/Low Health Flickering".start()
		#$Sprite2D.material.set_shader_parameter("progress", 1)
		
	if health<=0:
		dead.emit(global_position)
		$LowHealth.hide()
		$Orig.hide()
		$Border.hide()
		$"Death Animation".show()
		$"Death Animation".play()
		await get_tree().create_timer(0.4).timeout
		queue_free()

func jump_away(dir):
	var tween = get_tree().create_tween()
	tween.tween_property($".", "global_position", global_position+ dir*200 ,0.2)


func _on_area_2d_mouse_entered():
	hovered = true

func _on_timer_timeout():
	can_damage = true

func _on_crush_distance_body_entered(body):
	player_near = true


func _on_crush_distance_body_exited(body):
	player_near = false


func _on_hover_area_mouse_exited():
	hovered = false


func _on_hover_area_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("dash") and $Border.visible:
		crush.emit(global_position)
		queue_free()
		dead.emit(global_position)

func _on_low_health_flickering_timeout():
	if timer == 1:
		$LowHealth.show()
		timer = 2
	else:
		$LowHealth.hide()
		timer = 1
