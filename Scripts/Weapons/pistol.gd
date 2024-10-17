extends Weapon

func _ready() -> void:
    my_name = "Pistol"
    type = TYPE.FULL_AUTO
    ammo_type = AmmoManager.BULLET
    fire_rate = 0.05

func fire():
    super()

func _process(delta: float) -> void:
    super(delta)
