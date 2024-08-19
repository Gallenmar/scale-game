extends CharacterBody2D

var player_nearby :bool = false
var can_shoot : bool = true
var health = 40

signal shoot(pos, direction)

func _process(_delta):
	if can_shoot:
		can_shoot = false
		$ShootCooldown.start()
		var dir = ($Pivot/Shoot.global_position-global_position).normalized()
		shoot.emit($Pivot/Shoot.global_position, dir)
		$Pivot.rotate(deg_to_rad(90))
		dir = ($Pivot/Shoot.global_position-global_position).normalized()
		shoot.emit($Pivot/Shoot.global_position, dir)
		$Pivot.rotate(deg_to_rad(90))
		dir = ($Pivot/Shoot.global_position-global_position).normalized()
		shoot.emit($Pivot/Shoot.global_position, dir)
		$Pivot.rotate(deg_to_rad(90))
		dir = ($Pivot/Shoot.global_position-global_position).normalized()
		shoot.emit($Pivot/Shoot.global_position, dir)
		$Pivot.rotate(deg_to_rad(90))

func _on_shoot_cooldown_timeout():
	can_shoot = true

func take_damage():
	health -= 10
	if health<=0:
		queue_free()
