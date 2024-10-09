extends Weapon

func _ready() -> void:
	my_name = "Machinegun"
	type = TYPE.FULL_AUTO
	ammo_type = AMMO.BULLET
	fire_rate = 0.3

func fire():
	if can_shoot:
		# Shooting logic here
		print("~" + my_name + " FIRES~")
		trigger()

func _process(delta: float) -> void:
	super(delta)