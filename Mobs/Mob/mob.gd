extends CharacterBody2D

signal dead(pos:Vector2)
signal crush(pos)

@onready var player = get_node("/root/World/Player")
@export var speed = 300

var health :int = 30
var can_damage = true
var player_near = true
var hovered = false

func _ready():
	$LowHealth.hide()
	$Border.hide()

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
		#$Sprite2D.material.set_shader_parameter("progress", 1)
		$LowHealth.show()
		
	if health<=0:
		dead.emit(global_position)
		queue_free()




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
