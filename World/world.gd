extends Node2D

const BULLET = preload("res://Player/objects/bullet.tscn")

func _on_player_shoot(shooting_point_pos, directon):
	var bullet = BULLET.instantiate() as Area2D
	bullet.position = shooting_point_pos
	bullet.rotation = directon.angle()
	$Projectiles.add_child(bullet)
