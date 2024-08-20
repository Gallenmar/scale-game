extends Area2D

const FILE_BEGIN = "res://Rooms/room_"

func _on_body_entered(body):
	if body.is_in_group("Player"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		print(next_level_path)
		change_level(next_level_path)
		

func change_level(next_level_path):
	get_tree().change_scene_to_file(next_level_path)
