extends Node2D

const BULLET = preload("res://Player/objects/bullet.tscn")

func _ready():
	for killer in get_tree().get_nodes_in_group("Killers"):
		killer.connect('shoot', _on_killer_shoot)

func _on_killer_shoot(pos, dir):
	create_bullet(pos, dir)
	
func _on_player_shoot(shooting_point_pos, directon):
	create_bullet(shooting_point_pos, directon)

func create_bullet(pos, dir):
	var bullet = BULLET.instantiate() as Area2D
	bullet.position = pos
	bullet.rotation = dir.angle()
	$Projectiles.add_child(bullet)
