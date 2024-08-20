extends CharacterBody2D


var player_nearby :bool = false
var can_shoot : bool = true
var health = 400
var timer = 1

signal shoot(pos, direction)

func _ready():
	$Sprite2D/LowHealth.hide()
	$Sprite2D/Border.hide()

func _process(_delta):
	if health >150:
		if can_shoot:
			can_shoot = false
			$ShootCooldown.start()
			spiral_attack()
	elif (health <=150 and health>=100):
		if can_shoot:
			can_shoot = false
			$OneAttack.start()
			wave_attack()
	elif (health <100 and health>=50):
		if can_shoot:
			can_shoot = false
			$OneAttack2.start()
			laser_attack()
	elif health<50:
		if can_shoot:
			can_shoot = false
			$OneAttack3.start()
			cone_attack()
		

func spiral_attack():
	var dir = ($Pivot/Shoot.global_position - global_position).normalized()
	shoot.emit($Pivot/Shoot.global_position, dir)
	$Pivot.rotate(deg_to_rad(18))
	
func wave_attack():
	var num_bullets = 10  # Number of bullets in the wave
	var angle_range = deg_to_rad(90)  # 90 degrees in radians
	var start_angle = deg_to_rad(-45+90 * (randi() % 4))  
	var angle_increment = angle_range / (num_bullets - 1)  # Angle between each bullet
	
	for i in range(num_bullets):
		var angle = start_angle + i * angle_increment  # Calculate the angle for this bullet
		var dir = Vector2(cos(angle), sin(angle)).rotated(($Pivot/Shoot.global_position - global_position).angle()).normalized()  # Direction based on angle

		shoot.emit(global_position, dir)  # Emit the bullet in the calculated direction
	

@onready var player = get_node("/root/World/Player")

func laser_attack():

	var shoot_interval: float = 0.07
	var num_bullets: int = 5
	var player_position = player.global_position
	var dir = ($Pivot/Shoot.global_position - global_position).normalized()
	for i in range(num_bullets):
		shoot.emit(global_position, (player_position - global_position).normalized())
		for j in range(num_bullets):
			dir = ($Pivot/Shoot.global_position - global_position).normalized()
			shoot.emit(global_position, dir)
			$Pivot.rotate(deg_to_rad(90))
		await get_tree().create_timer(shoot_interval).timeout

func cone_attack():

	var shoot_interval: float = 0.07
	var num_bullets: int = 5
	var player_position = Globals.player_pos
	$Pivot.look_at(player_position)
	var dir = ($Pivot/Shoot.global_position - global_position).normalized()
	for i in range(num_bullets):
		shoot.emit($Pivot/Shoot.global_position, (player_position - global_position).normalized())
		$Pivot.rotate(deg_to_rad(-18))
		dir = ($Pivot/Shoot.global_position - global_position).normalized()
		for j in range(num_bullets):
			shoot.emit($Pivot/Shoot.global_position, dir)
		$Pivot.rotate(deg_to_rad(9))
		dir = ($Pivot/Shoot.global_position - global_position).normalized()
		for j in range(num_bullets):
			shoot.emit($Pivot/Shoot.global_position, dir)
		$Pivot.rotate(deg_to_rad(27))
		dir = ($Pivot/Shoot.global_position - global_position).normalized()
		for j in range(num_bullets):
			shoot.emit($Pivot/Shoot.global_position, dir)
		$Pivot.rotate(deg_to_rad(-9))
		dir = ($Pivot/Shoot.global_position - global_position).normalized()
		for j in range(num_bullets):
			shoot.emit($Pivot/Shoot.global_position, dir)
		$Pivot.rotate(deg_to_rad(-9))

		await get_tree().create_timer(shoot_interval).timeout
		
func _on_shoot_cooldown_timeout():
	can_shoot = true

func take_damage():
	health -= 10
	if health <=10:
		$"Sprite2D/LowHealth/Low Health Flickering".start()
	if health<=0:
		queue_free()


func _on_one_attack_timeout():
	can_shoot = true
func _on_one_attack2_timeout():
	can_shoot = true
func _on_one_attack3_timeout():
	can_shoot = true



func _on_low_health_flickering_timeout():
	if timer == 1:
		$Sprite2D/LowHealth.show()
		timer = 2
	else:
		$Sprite2D/LowHealth.hide()
		timer = 1
