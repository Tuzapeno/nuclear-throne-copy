class_name AmmoChest
extends Chest

func action() -> void:
	var ammo_type = Globals.player.weapon_primary.get_ammo_type()
	AmmoManager.add_ammo_pickup(ammo_type, true)
	