extends Weapon

func _ready() -> void:
    my_name = "Pistol"
    type = TYPE.SEMI_AUTO
    ammo_type = AMMO.BULLET
    fire_rate = 0.2

func fire():
    if can_shoot:
        # Shooting logic here
        print("~" + my_name + " FIRES~")
        trigger()

func _process(delta: float) -> void:
    super(delta)
