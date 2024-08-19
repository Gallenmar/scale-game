extends Node2D

const BULLET = preload("res://Objects/bullet/bullet.tscn")
const TOXIN = preload("res://Objects/toxin/toxin.tscn")
const ITEM = preload("res://Objects/item/item.tscn")

@export var item_def_chance = 30
@export var item_dash_chance = 70
var item_chance = item_def_chance

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
	create_bullet(pos, dir)

func _on_killer_shoot(pos, dir):
	create_bullet(pos, dir)

func _on_mob_dead(pos):
	if randi() % 100 >=item_chance: #chanse 50%
		var item = ITEM.instantiate() as Area2D
		item.position = pos
		$Items.call_deferred("add_child", item)
		item_chance = item_def_chance

func _on_mob_crush(pos):
	Globals.is_vulnurable = false
	$Player.dash_start(pos)
	var tween = get_tree().create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(1.3,1.3),$Player/DashTimer.wait_time / 2)
	tween.tween_property($Player/Camera2D, "zoom", Vector2(1,1),$Player/DashTimer.wait_time / 2)
	item_chance = item_dash_chance

func _on_player_shoot(shooting_point_pos, directon):
	create_toxin(shooting_point_pos, directon)

func create_bullet(pos, dir):
	var bullet = BULLET.instantiate() as Area2D
	bullet.position = pos
	bullet.rotation = dir.angle()
	$Projectiles.call_deferred("add_child", bullet)

func create_toxin(pos, dir):
	var toxin = TOXIN.instantiate() as Area2D
	toxin.position = pos
	toxin.rotation = dir.angle()
	$Projectiles.call_deferred("add_child", toxin)

func _on_player_dead():
	$UI.game_over()

func _process(_delta):
	
	if Input.is_action_pressed("pause"): # !todo this needs some work
		if get_tree().paused:
			get_tree().paused = false
		else:
			get_tree().paused = true
