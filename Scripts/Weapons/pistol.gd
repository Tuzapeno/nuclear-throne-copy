extends BulletWeapon

func _process(delta: float) -> void:
    super(delta)


func fire() -> void:
    create_small_bullet()
