extends ItemDrop

# If the player picks up ammo we do the following order:
# 1. Give ammo to the primary weapon if not full
# 2. Give ammo to the secondary weapon if not full
# 3. Give ammo to a random ammo type if both full

func pickup_action() -> void:
	if not Globals.player:
		return

	var primary = Globals.player.get_primary_weapon()
	var extra = Globals.player.get_extra_weapon()

	if not extra:
		AmmoManager.add_ammo_pickup(primary.get_ammo_type())
		return

	if randf() < 0.5:
		AmmoManager.add_ammo_pickup(primary.get_ammo_type())
	else:
		AmmoManager.add_ammo_pickup(extra.get_ammo_type())
	
		

	
	