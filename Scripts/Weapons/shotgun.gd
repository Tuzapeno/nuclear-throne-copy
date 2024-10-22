extends ShellWeapon

const n_shells := 1

func _process(delta: float) -> void:
	super(delta)


func fire():
	for i in range(0, n_shells):
		var shell := create_shell(shell_scn)
		shell.direction = shell.direction.rotated(randf_range(-spread_value, spread_value))
		shell.air_resistance = randi_range(base_resistance - 5, base_resistance + 5)
