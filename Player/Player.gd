extends CharacterBody2D

signal shoot(shooting_point_pos, directon)
signal dead()

@export var max_speed = 900
@export var acceleration = 3000
@export var friction = 3000

var can_shoot = true
var player_alive = true

func _process(delta):
	if player_alive:
		look_at(get_global_mouse_position())

func _physics_process(delta):
	if player_alive:
		player_movement(delta)
		if Input.is_action_pressed("shoot") and can_shoot:
			can_shoot = false
			$Timer.start()
			var directon = (get_global_mouse_position() - position).normalized()
			shoot.emit(%ShootingPoint.global_position, directon)

func _on_timer_timeout():
	can_shoot = true
	
var input = Vector2.ZERO
func get_input():
	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input.normalized()
	
func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * acceleration * delta)
		velocity = velocity.limit_length(max_speed)
	move_and_slide()
	Globals.player_pos = global_position

func take_damage():
	Globals.health -= 10
	if Globals.health<=0:
		dead.emit()
		player_alive = false
