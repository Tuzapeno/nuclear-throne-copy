extends MachineGun


func fire() -> void:
	var bullet1 = create_small_bullet()
	var bullet2 = create_small_bullet()

	bullet1.global_position.y += randi_range(-3, 3)
	bullet2.global_position.y += randi_range(-3, 3)
 

