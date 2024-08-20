extends WorldParent

@export var mob_scene: PackedScene
@onready var player = $Player

func _on_entrance_body_exited(body):
	$Exit2.is_opened = false
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
	
	connect_enemies()

func _process(_delta):
	#get_tree().get_nodes_in_group("Player")
	if get_tree().get_nodes_in_group("Enemies").size() <=0:
		$Exit2.is_opened = true



