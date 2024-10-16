extends Weapon

func _ready() -> void:
	my_name = "Shotgun"
	type = TYPE.SEMI_AUTO
	ammo_type = AmmoManager.SHELL
	fire_rate = 1

func fire():
	super()

func _process(delta: float) -> void:
	super(delta)