extends Node

func change_scene(scene: PackedScene, scene_name: String = "no name") -> void:
	match get_tree().change_scene_to_packed(scene):
		OK:
			print("Scene changed successfully to ", scene_name)
		ERR_CANT_CREATE:
			print("Can't create scene ", scene_name)
		ERR_INVALID_PARAMETER:
			print("Scene ", scene_name, " is invalid!")

