extends Chest

var weapon_scene: PackedScene = null

func get_random_weapon() -> PackedScene:
	var weapon_chest = randi() % 3
	match weapon_chest:
		0:
			weapon_scene = preload(Globals.weapon_drop_scene_path + "pistol_drop.tscn")
		1:
			weapon_scene = preload(Globals.weapon_drop_scene_path + "shotgun_drop.tscn")
		2:
			weapon_scene = preload(Globals.weapon_drop_scene_path + "machinegun_drop.tscn")

	return weapon_scene


func action() -> void:
	var weapon = get_random_weapon().instantiate()
	weapon.global_position = global_position
	get_parent().add_child(weapon)
	