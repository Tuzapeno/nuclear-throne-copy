extends ShellWeapon
class_name Shotgun

const n_shells := 7

func _process(delta: float) -> void:
	super(delta)

func fire():
	for i in range(0, n_shells):
		var shell := create_shell(shell_scn)
		shell.direction = shell.direction.rotated(randf_range(-spread_value, spread_value))
