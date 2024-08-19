extends Node2D

const BULLET = preload("res://Objects/bullet/bullet.tscn")
const ITEM = preload("res://Objects/item/item.tscn")

func _ready():
	for i in get_tree().get_nodes_in_group("Killers"):
		i.connect('shoot', _on_killer_shoot)
	for i in get_tree().get_nodes_in_group("Mobs"):
		i.connect('dead', _on_mob_dead)
	for i in get_tree().get_nodes_in_group("Mobs"):
		i.connect('crush', _on_mob_crush)
	for i in get_tree().get_nodes_in_group("Bcells"):
		i.connect('shoot', _on_bcell_shoot)

func _on_bcell_shoot(pos, dir):
	create_bullet(pos, dir, false)

func _on_killer_shoot(pos, dir):
	create_bullet(pos, dir, false)

func _on_mob_dead(pos):
	if randi() % 2 == 0: #chanse 50%
		var item = ITEM.instantiate() as Area2D
		item.position = pos
		$Items.call_deferred("add_child", item)

func _on_mob_crush(pos):
	Globals.is_vulnurable = false
	$Player.dash_start(pos)

func _on_player_shoot(shooting_point_pos, directon):
	create_bullet(shooting_point_pos, directon, true)

func create_bullet(pos, dir, is_player):
	var bullet = BULLET.instantiate() as Area2D
	bullet.player = is_player
	bullet.position = pos
	bullet.rotation = dir.angle()
	$Projectiles.call_deferred("add_child", bullet)


func _on_player_dead():
	$UI.game_over()

func _process(_delta):
	
	if Input.is_action_pressed("pause"): # !todo this needs some work
		if get_tree().paused:
			get_tree().paused = false
		else:
			get_tree().paused = true
