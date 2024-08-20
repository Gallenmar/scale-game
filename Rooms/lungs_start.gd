extends Node2D

@export var mob_scene: PackedScene
@onready var player = $Player

func _on_entrance_body_exited(body):
	var mob = mob_scene.instantiate()
	for i in $"Spawn Locations".get_children():
		mob.global_position = i.global_position
		mob.player = player
		add_child(mob)


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


