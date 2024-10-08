extends Node2D
class_name WorldParent

const BULLET = preload("res://Objects/bullet/bullet.tscn")
const TOXIN = preload("res://Objects/toxin/toxin.tscn")
const WASTE = preload("res://Objects/waste/waste.tscn")
const ITEM = preload("res://Objects/item/item.tscn")

@export var item_def_chance = 30
@export var item_dash_chance = 70

#@onready var music = $AudioStreamPlayer2D
var bg_music := AudioStreamPlayer.new()

var item_chance = item_def_chance

func _ready():
	#music.play(0.0)
	bg_music.stream = load("res://Music/lungs fight.mp3")
	bg_music.autoplay = true
	add_child(bg_music)
	connect_enemies()

func connect_enemies():
	for i in get_tree().get_nodes_in_group("Player"):
		i.connect('shoot', _on_player_shoot)
	for i in get_tree().get_nodes_in_group("Player"):
		i.connect('lash', _on_player_lash)
	for i in get_tree().get_nodes_in_group("Player"):
		i.connect('dead', _on_player_dead)
	for i in get_tree().get_nodes_in_group("Killers"):
		i.connect('shoot', _on_killer_shoot)
	for i in get_tree().get_nodes_in_group("Killers"):
		i.connect('dead', _on_enemy_dead)
	for i in get_tree().get_nodes_in_group("Killers"):
		i.connect('crush', _on_enemy_crush)
	for i in get_tree().get_nodes_in_group("Mobs"):
		i.connect('dead', _on_enemy_dead)
	for i in get_tree().get_nodes_in_group("Mobs"):
		i.connect('crush', _on_enemy_crush)
	for i in get_tree().get_nodes_in_group("Bcells"):
		i.connect('shoot', _on_bcell_shoot)
	for i in get_tree().get_nodes_in_group("Bcells"):
		i.connect('dead', _on_enemy_dead)
	for i in get_tree().get_nodes_in_group("Bcells"):
		i.connect('crush', _on_enemy_crush)
	for i in get_tree().get_nodes_in_group("Boss"):
		i.connect('shoot', _on_boss_shoot)
	
func _on_boss_shoot(pos, dir):
	create_boss_bullet(pos, dir)

func _on_bcell_shoot(pos, dir):
	create_bullet(pos, dir)

func _on_killer_shoot(pos, dir):
	create_bullet(pos, dir)

func _on_enemy_dead(pos):
	if randi() % 100 >=item_chance: #chanse 50%
		var item = ITEM.instantiate() as Area2D
		item.position = pos
		$Items.call_deferred("add_child", item)
		item_chance = item_def_chance

func _on_enemy_crush(pos):
	Globals.is_vulnurable = false
	$Player.dash_start(pos)
	var tween = get_tree().create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(1.3,1.3),$Player/DashTimer.wait_time / 2)
	tween.tween_property($Player/Camera2D, "zoom", Vector2(1,1),$Player/DashTimer.wait_time / 2)
	item_chance = item_dash_chance

func _on_player_shoot(shooting_point_pos, directon):
	create_toxin(shooting_point_pos, directon)

func _on_player_lash(shooting_point_pos, directon):
	create_waste(shooting_point_pos, directon)

func create_boss_bullet(pos, dir):
	var bullet = BULLET.instantiate() as Area2D
	bullet.position = pos
	bullet.rotation = dir.angle()
	$Projectiles.call_deferred("add_child", bullet)

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

func create_waste(pos, dir):
	var waste = WASTE.instantiate() as RigidBody2D
	waste.position = pos
	waste.linear_velocity = dir * 100
	$Projectiles.call_deferred("add_child", waste)
	var tween = get_tree().create_tween()
	tween.tween_property(waste, "linear_velocity", Vector2.ZERO,2)

func _on_player_dead():
	$UI.game_over()


