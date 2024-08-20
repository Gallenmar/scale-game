extends WorldParent

@export var mob_scene: PackedScene
@export var killer_scene: PackedScene
@export var bcell_scene: PackedScene
@onready var player = $Player

var entered = false

func _ready():
	$UI/ColorRect.hide()
	$UI/Label.hide()

func _on_entrance_body_exited(body):
	if !entered:
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
		
		var bcell = bcell_scene.instantiate()
		bcell.global_position = $"Spawn Locations/bcell".global_position
		add_child(bcell)
		
		var killer = killer_scene.instantiate()
		killer.global_position = $"Spawn Locations/killer".global_position
		add_child(killer)
		connect_enemies()
		entered = true

func _process(_delta):
	#get_tree().get_nodes_in_group("Player")
	if get_tree().get_nodes_in_group("Enemies").size() <=0:
		$UI/ColorRect.show()
		$UI/Label.show()
		get_tree().paused = true



