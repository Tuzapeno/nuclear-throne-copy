extends Node

@onready var level_scene: PackedScene = preload("res://Scenes/level.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_U:
			change_scene(level_scene, "Level")



func change_scene(scene: PackedScene, scene_name: String = "no name") -> void:
	
	# Save player to ensure persistance
	if Globals.player != null:
		Globals.player = Utils.clone_node(Globals.player) as CharacterBody2D
	
	
	match get_tree().change_scene_to_packed(scene):
		OK:
			print("Scene changed successfully to ", scene_name)
		ERR_CANT_CREATE:
			print("Can't create scene ", scene_name)
		ERR_INVALID_PARAMETER:
			print("Scene ", scene_name, " is invalid!")

	


