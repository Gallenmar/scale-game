extends CharacterBody2D

var player_nearby :bool = false
var can_shoot : bool = true
var health = 40

signal shoot(pos, direction)

func _process(_delta):
	if(player_nearby):
		$Pivot.look_at(Globals.player_pos)
		if can_shoot:
			var pos:Vector2 = $Pivot/Shoot.global_position
			var dir:Vector2 = (Globals.player_pos - position).normalized()
			shoot.emit(pos, dir)
			can_shoot = false
			$ShootCooldown.start()

func _on_attack_area_body_entered(_body):
	player_nearby = true


func _on_attack_area_body_exited(_body):
	player_nearby = false


func _on_shoot_cooldown_timeout():
	can_shoot = true

func take_damage():
	health -= 10
	if health<=0:
		queue_free()
