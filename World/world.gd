extends Node2D

const BULLET = preload("res://Objects/bullet/bullet.tscn")
const ITEM = preload("res://Objects/item/item.tscn")

func _ready():
	for i in get_tree().get_nodes_in_group("Killers"):
		i.connect('shoot', _on_killer_shoot)
	for i in get_tree().get_nodes_in_group("Mobs"):
		i.connect('dead', _on_mob_dead)
	for i in get_tree().get_nodes_in_group("Bcells"):
		i.connect('shoot', _on_bcell_shoot)

func _on_bcell_shoot(pos, dir):
	create_bullet(pos, dir)

func _on_killer_shoot(pos, dir):
	create_bullet(pos, dir)

func _on_mob_dead(pos):
	if randi() % 3 == 0: #chanse 33%
		var item = ITEM.instantiate() as Area2D
		item.position = pos
		$Items.add_child(item)
	
func _on_player_shoot(shooting_point_pos, directon):
	create_bullet(shooting_point_pos, directon)

func create_bullet(pos, dir):
	var bullet = BULLET.instantiate() as Area2D
	bullet.position = pos
	bullet.rotation = dir.angle()
	$Projectiles.add_child(bullet)


func _on_player_dead():
	$UI.game_over()

func _process(delta):
	if Input.is_action_pressed("pause"): # !todo this needs some work
		if get_tree().paused:
			get_tree().paused = false
		else:
			get_tree().paused = true
