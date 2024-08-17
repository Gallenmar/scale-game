extends CharacterBody2D

var player_nearby :bool = false
var can_shoot : bool = true

signal shoot(pos, direction)

func _process(delta):
	if(player_nearby):
		$Pivot.look_at(Globals.player_pos)
		if can_shoot:
			var pos:Vector2 = $Pivot/Shoot.global_position
			var dir:Vector2 = (Globals.player_pos - position).normalized()
			shoot.emit(pos, dir)
			can_shoot = false
			$ShootCooldown.start()

func _on_attack_area_body_entered(body):
	player_nearby = true


func _on_attack_area_body_exited(body):
	player_nearby = false


func _on_shoot_cooldown_timeout():
	can_shoot = true
