extends Node

var portal_scene = preload("res://Scenes/portal.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		# Add ammo for all weapons
		if event.keycode == KEY_F1 and event.pressed:
			AmmoManager.add_ammo_all(999)
		# Goto next level
		if event.keycode == KEY_F2 and event.pressed:
			SceneManager.change_level()
		# Switch camera mode
		if event.keycode == KEY_F3 and event.pressed:
			if Globals.camera.is_locked():
				Globals.camera.set_free()
			else:
				Globals.camera.set_locked()
		# Summon portal
		if event.keycode == KEY_F4 and event.pressed:
			var portal = portal_scene.instantiate()
			get_tree().root.add_child(portal)
			portal.global_position = Globals.player.global_position
		
			

        