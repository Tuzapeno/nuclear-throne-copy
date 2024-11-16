class_name AmmoChest
extends Chest

func action() -> void:
	var ammo_type = Globals.player.weapon_primary.get_ammo_type()

	if ammo_type == AmmoTypes.BULLET_TYPE:
		AmmoManager.add_ammo(ammo_type, 32)
	elif ammo_type == AmmoTypes.SHELL_TYPE:
		AmmoManager.add_ammo(ammo_type, 12)