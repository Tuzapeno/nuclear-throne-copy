class_name ShellWeapon
extends Weapon

var shell_scn := preload("res://Scenes/Weapons/shell.tscn")
var spread_value := 0.5
var base_resistance := 10


func create_shell(shell_scene: PackedScene) -> Shell:
	var shell: Shell = shell_scene.instantiate()
	shell.global_position = get_tip_position()
	shell.direction = (get_global_mouse_position() - global_position).normalized()
	get_parent().add_sibling(shell)
	return shell
