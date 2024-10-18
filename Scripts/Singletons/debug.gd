extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		# Add ammo for all weapons
		if event.keycode == KEY_F1 and event.pressed:
			AmmoManager.add_ammo_all(10)
		# Goto next level
		if event.keycode == KEY_F2 and event.pressed:
			SceneManager.change_level()
		# Show current player weapons
		if event.keycode == KEY_F3 and event.pressed:
			Globals.player.show_weapons()

        