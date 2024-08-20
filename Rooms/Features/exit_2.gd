extends Area2D

const FILE_BEGIN = "res://Rooms/room_"
var is_opened:bool=false

func _ready():
	$Opened.hide()

func _process(delta):
	if is_opened:
		$Opened.show()
	else:
		$Opened.hide()

func _on_body_entered(body):
	if body.is_in_group("Player") and is_opened:
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		print(next_level_path)
		change_level(next_level_path)
		

func change_level(next_level_path):
	get_tree().change_scene_to_file(next_level_path)

func open_gate():
	is_opened = true
