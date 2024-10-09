extends Weapon

func _ready() -> void:
	my_name = "Pistol"
	type = TYPE.SEMI_AUTO
	ammo_type = AMMO.BULLET
	fire_rate = 0.2

func fire():
	super()

func _process(delta: float) -> void:
	super(delta)