extends Node

@onready var level_scene: PackedScene = preload("res://Scenes/level.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_U and event.pressed:
			change_level()



func change_scene(scene: PackedScene, scene_name: String = "no name") -> void:

	match get_tree().change_scene_to_packed(scene):
		OK:
			print("Scene changed successfully to ", scene_name)
		ERR_CANT_CREATE:
			print("Can't create scene ", scene_name)
		ERR_INVALID_PARAMETER:
			print("Scene ", scene_name, " is invalid!")



func change_level() -> void: # TODO: Adicionar parâmetros

	# TODO: Criar tela de loading

	var tree_root: Window = get_tree().root
	var old_level: Node = tree_root.get_node("Level")
	var new_level: Node = level_scene.instantiate() # TODO: Adicionar parâmetros
	new_level.name = "Level"

	if old_level != null:
		# Desacoplar o player da cena atual
		old_level.remove_child(Globals.player)

		# Apagar a cena atual
		old_level.free()

	# Adicionar parametros aqui...
	# Adicionar novo level na cena raiz
	tree_root.add_child(new_level, true)

 	# Exibir a nova cena após a cena rodar sua função _ready
	await new_level.level_loaded
	

	