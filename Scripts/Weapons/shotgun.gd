extends ShellWeapon

func _process(delta: float) -> void:
	super(delta)


func fire():
	create_shell(shell_scn)
