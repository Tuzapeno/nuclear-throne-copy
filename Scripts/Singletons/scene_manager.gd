extends Node

@onready var level_scene: PackedScene = preload("res://Scenes/level.tscn")

var current_scene: String = "MainMenu"


# TODO: Add to debug class

# func _input(event: InputEvent) -> void:
# 	if event is InputEventKey:
# 		if event.keycode == KEY_U and event.pressed:
# 			change_level()



func change_scene(scene: PackedScene, scene_name: String = "no name") -> void:

	# Remove old scene
	var main_node := get_tree().root.get_node("Main")

	if not main_node:
		printerr("Main node not found! at scene_manager.gd")
		return

	if main_node.has_node(current_scene):
		main_node.get_node(current_scene).queue_free()

	# Load new scene
	var new_scene := scene.instantiate()
	new_scene.name = scene_name
	main_node.add_child(new_scene)

	# Move to top
	main_node.move_child(new_scene, 0)

	current_scene = scene_name


func change_level() -> void: # TODO: Adicionar parâmetros

	# TODO: Criar tela de loading

	var main_node := get_tree().root.get_node("Main")
	assert(is_instance_valid(main_node), "Main node not found! at scene_manager.gd")

	var old_level: Node = main_node.get_node("Level")
	assert(is_instance_valid(old_level), "Old level not found! at scene_manager.gd")

	var new_level: Node = level_scene.instantiate() # TODO: Adicionar parâmetros
	new_level.name = "Level"

	if old_level != null:
		# Desacoplar o player da cena atual
		old_level.remove_child(Globals.player)

		# Apagar a cena atual
		old_level.free()

	# Adicionar parametros aqui...
	# Adicionar novo level na cena raiz
	main_node.add_child(new_level, true)

 	# Exibir a nova cena após a cena rodar sua função _ready
	#await new_level.level_loaded
