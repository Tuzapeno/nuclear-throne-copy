extends Weapon

func _ready() -> void:
	my_name = "Machinegun"
	type = TYPE.FULL_AUTO
	ammo_type = AMMO.BULLET
	fire_rate = 3

func fire():
	super()

func _process(delta: float) -> void:
	super(delta)