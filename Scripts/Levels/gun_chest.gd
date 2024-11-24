class_name GunChest
extends Chest

var weapon_scene: PackedScene = null
@onready var spawn: Marker2D = $SpawnPoint

func get_random_weapon() -> PackedScene:
	var weapon_chest = randi_range(0, 4)
	match weapon_chest:
		0:
			weapon_scene = preload(Globals.weapon_drop_scene_path + "pistol_drop.tscn")
		1:
			weapon_scene = preload(Globals.weapon_drop_scene_path + "shotgun_drop.tscn")
		2:
			weapon_scene = preload(Globals.weapon_drop_scene_path + "machinegun_drop.tscn")
		3:
			weapon_scene = preload(Globals.weapon_drop_scene_path + "auto shotgun_drop.tscn")
		4:
			weapon_scene = preload(Globals.weapon_drop_scene_path + "lmg_drop.tscn")

	return weapon_scene


func action() -> void:
	var weapon = get_random_weapon().instantiate()
	weapon.global_position = spawn.global_position
	call_deferred("add_weapon_to_parent", weapon)

func add_weapon_to_parent(weapon: Node) -> void:
	get_parent().add_child(weapon)
