extends CharacterBody2D

signal shoot(shooting_point_pos, directon)
signal dead()

@export var max_speed = 1000
@export var acceleration = 6000
@export var friction = 10000

var can_shoot = true
var player_alive = true
var dash_pos = null
var dash_velocity = 0

func _ready():
	Globals.connect("vulnurability_change", start_vuln_timer)
	$InVuln.hide()

func _process(_delta):
	if player_alive:
		look_at(get_global_mouse_position())

func _physics_process(delta):
	if player_alive:
		player_movement(delta)
		if Input.is_action_pressed("shoot") and can_shoot:
			can_shoot = false
			$ShootingTimer.start()
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
	if dash_pos == null:
		if input == Vector2.ZERO:
			if velocity.length() > (friction * delta):
				velocity -= velocity.normalized() * (friction * delta)
			else:
				velocity = Vector2.ZERO
		else:
			velocity += (input * acceleration * delta)
			velocity = velocity.limit_length(max_speed)
	else:
		velocity = dash_velocity * delta * 60
		print("d", delta)
		print("v", velocity)
		print("")
	move_and_slide()
	Globals.player_pos = global_position

func start_vuln_timer():
	$InvulnTimer.start()
	$InVuln.show()

func _on_invuln_timer_timeout():
	Globals.is_vulnurable = true
	$InVuln.hide()

func take_damage():
	if Globals.is_vulnurable:
		Globals.health -= 10
		if Globals.health<=0:
			dead.emit()
			player_alive = false
		
func insta_kill():
	if Globals.is_vulnurable:
		Globals.health -= 100
		dead.emit()
		player_alive = false

func dash_start(pos):
	print("current pos ", global_position)
	print("target pos ", pos)
	dash_pos = pos
	$DashTimer.start()
	var dir = (pos - global_position)
	print("dir", dir)
	dash_velocity = dir / $DashTimer.wait_time
	print("dv", dash_velocity)
	set_collision_layer_value(1,false)

func _on_dash_timer_timeout():
	print("res pos", global_position)
	dash_pos = null
	Globals.is_vulnurable = false
	velocity = velocity.limit_length(max_speed)
	set_collision_layer_value(1,true)
	
#func handle_dash(delta, pos):
	#print("target pos", pos)
	#print("pos before: ", global_position)	
	#var dir = (pos - global_position)
	#print("dir", dir)
	#print("distance",(pos - global_position))
	#velocity = dir
	#print("v", velocity)
	#move_and_slide()
	#print("pos after: ", global_position)
	#print("")
#


