extends ItemDrop

func pickup_action() -> void:
	if not Globals.player:
		return

	Globals.player.heal(2)
	Globals.create_floating_text("HEALTH 2", Globals.player.global_position, "health")
