extends Node2D

@export var mob_scene: PackedScene
@onready var player = $Player



func _on_entrance_body_exited(body):
	var mob = mob_scene.instantiate()
	mob.global_position = $"Spawn Locations/Marker2D".global_position
	mob.player = player
	add_child(mob)
	var mob2 = mob_scene.instantiate()
	mob2.global_position = $"Spawn Locations/Marker2D2".global_position
	mob2.player = player
	add_child(mob2)
	var mob3 = mob_scene.instantiate()
	mob3.global_position = $"Spawn Locations/Marker2D3".global_position
	mob3.player = player
	add_child(mob3)


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass





