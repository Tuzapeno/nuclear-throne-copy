extends Weapon

var small_bullet_scene := preload("res://Scenes/Weapons/small_bullet.tscn")


func _ready() -> void:
    my_name = "Pistol"
    type = TYPE.SEMI_AUTO
    ammo_type = AmmoManager.BULLET
    fire_rate = 0.1

func fire() -> void:
    if not can_fire():
        return
    super()

    var bullet: SmallBullet = small_bullet_scene.instantiate()
    bullet.global_position = get_tip_position()
    bullet.direction = (get_global_mouse_position() - global_position).normalized()
    get_parent().add_sibling(bullet)


func _process(delta: float) -> void:
    super(delta)
