extends ShellWeapon

func _process(delta: float) -> void:
	super(delta)


func fire():
	for i in range(0, 7):
		var shell := create_shell(shell_scn)
		shell.direction = shell.direction.rotated(randf_range(-spread_value, spread_value))
		shell.air_resistance = randi_range(base_resistance - 5, base_resistance + 5)
