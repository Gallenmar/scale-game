extends CharacterBody2D

signal shoot(shooting_point_pos, directon)
signal dead()
signal lash(shooting_point_pos, directon)

@export var max_speed = 1000
@export var acceleration = 6000
@export var friction = 10000
@export var dash_scatter_radius = 300

@export var max_speed_80 = 600
@export var max_speed_60 = 800
@export var max_speed_40 = 1000
@export var max_speed_20 = 1200
@export var max_speed_0 = 1400
@export var scale_80 = 0.13
@export var scale_60 = 0.1
@export var scale_40 = 0.07
@export var scale_20 = 0.05
@export var scale_0 = 0.03

var can_shoot = true
var dash_pos = null
var dash_velocity = 0

func _ready():
	Globals.connect("vulnurability_change", start_vuln_timer)
	$InVuln.hide()

func _process(_delta):
	if Globals.health > 0:
		if Globals.health > 80:
			scale_player(scale_80, max_speed_80)
		elif Globals.health > 60:
			scale_player(scale_60, max_speed_60)
		elif Globals.health > 40:
			scale_player(scale_40, max_speed_40)
		elif Globals.health > 20:
			scale_player(scale_20, max_speed_20)
		elif Globals.health > 0:
			scale_player(scale_0, max_speed_0)
		look_at(get_global_mouse_position())
	else:
		handle_death()
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

func scale_player(new_scale, new_speed):
	max_speed = new_speed
	$AnimatedSprite2D.scale = Vector2(new_scale,new_scale)
	$InVuln.scale = Vector2(new_scale,new_scale)
	$CollisionShape2D.scale = Vector2(new_scale*100,new_scale*100)
	$CollisionShape2D.position = Vector2(360 * new_scale *1.4,0)

func _physics_process(delta):
	if Globals.health > 0:
		player_movement(delta)
		if Input.is_action_pressed("shoot") and can_shoot:
			can_shoot = false
			$ShootingTimer.start()
			var directon = (get_global_mouse_position() - position).normalized()
			shoot.emit(%ShootingPoint.global_position, directon)
		if Input.is_action_just_pressed("lash"):
			Globals.health -= 10
			
			var direction = ($PivotPoint/Lash1.global_position - global_position).normalized()
			lash.emit($PivotPoint/Lash1.global_position, direction)
			direction = ($PivotPoint/Lash2.global_position - global_position).normalized()
			lash.emit($PivotPoint/Lash2.global_position, direction)
			direction = ($PivotPoint/Lash3.global_position - global_position).normalized()
			lash.emit($PivotPoint/Lash3.global_position, direction)
			direction = ($PivotPoint/Lash4.global_position - global_position).normalized()
			lash.emit($PivotPoint/Lash4.global_position, direction)
			
			var new_pos = global_position + (%ShootingPoint.global_position - global_position) * 4
			dash_start(new_pos)

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
			handle_death()
		
func insta_kill():
	if Globals.is_vulnurable:
		handle_death()

func handle_death():
	Globals.health -= 100
	dead.emit()
	$AnimatedSprite2D.scale = Vector2(scale_0,scale_0)
	$InVuln.scale = Vector2(scale_0,scale_0)
	velocity= Vector2.ZERO

func dash_start(target_pos):
	dash_pos = target_pos
	$DashTimer.start()
	var dir = (target_pos - global_position)
	dash_velocity = dir / $DashTimer.wait_time
	set_collision_layer_value(1,false)

func _on_dash_timer_timeout():
	dash_pos = null
	Globals.is_vulnurable = false
	velocity = velocity.limit_length(max_speed)
	set_collision_layer_value(1,true)
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		var in_range = enemy.global_position.distance_to(global_position) < dash_scatter_radius
		if in_range:
			var dir = (enemy.global_position - global_position).normalized()
			enemy.jump_away(dir)
