class_name BulletWeapon
extends Weapon

var small_bullet_scn := preload("res://Scenes/Weapons/small_bullet.tscn")

func create_small_bullet(small_bullet_scene: PackedScene) -> void:
    var bullet: SmallBullet = small_bullet_scene.instantiate()
    bullet.global_position = get_tip_position()
    bullet.direction = (get_global_mouse_position() - global_position).normalized()
    get_parent().add_sibling(bullet)
