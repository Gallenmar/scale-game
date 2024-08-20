extends WorldParent

@export var mob_scene: PackedScene
@export var killer_scene: PackedScene
@export var bcell_scene: PackedScene
@export var white_scene: PackedScene
@onready var player = $Player

var entered = false

func _on_entrance_body_exited(body):
	if !entered:
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
		var mob4 = mob_scene.instantiate()
		mob4.global_position = $"Spawn Locations/Marker2D4".global_position
		mob4.player = player
		add_child(mob4)
		var mob5 = mob_scene.instantiate()
		mob5.global_position = $"Spawn Locations/Marker2D5".global_position
		mob5.player = player
		add_child(mob5)
		var mob6 = mob_scene.instantiate()
		mob6.global_position = $"Spawn Locations/Marker2D6".global_position
		mob6.player = player
		add_child(mob6)
		
		var bcell = bcell_scene.instantiate()
		bcell.global_position = $"Spawn Locations/bcell".global_position
		add_child(bcell)
		
		var killer = killer_scene.instantiate()
		killer.global_position = $"Spawn Locations/killer".global_position
		add_child(killer)
		var killer2 = killer_scene.instantiate()
		killer2.global_position = $"Spawn Locations/killer2".global_position
		add_child(killer2)
		
		var white = white_scene.instantiate()
		white.global_position = $"Spawn Locations/white".global_position
		add_child(white)
		
		connect_enemies()
		entered = true

func _process(_delta):
	#get_tree().get_nodes_in_group("Player")
	if get_tree().get_nodes_in_group("Enemies").size() <=0:
		$Exit2.is_opened = true



