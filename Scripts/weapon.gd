class_name Weapon
extends Node2D

# TODO: Full auto has no cooldown on shooting, need to fix

enum TYPE { SEMI_AUTO, FULL_AUTO, BURST }
enum AMMO { BULLET, SHELL }

var my_name: String = "Weapon"
var type: int = TYPE.SEMI_AUTO
var ammo_type: int = AMMO.BULLET
var fire_rate: float = 1.0
var shoot_cooldown: float = 0.0
var can_shoot: bool = true

# TODO: rearrange order of fire() and its overrides to prevent shooting when can_shoot is false

func fire() -> void:
    if not can_shoot:
        return

    print("~" + my_name + " FIRES~")

    shoot_cooldown = fire_rate
    can_shoot = false

func _process(delta: float) -> void:
    if shoot_cooldown > 0:
        shoot_cooldown -= delta

    if shoot_cooldown <= 0:
        can_shoot = true