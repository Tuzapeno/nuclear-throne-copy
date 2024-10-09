class_name Weapon
extends Node2D

# TODO: Full auto has no cooldown on shooting, need to fix

enum TYPE { SEMI_AUTO, FULL_AUTO, BURST }
enum AMMO { BULLET, SHELL }

@export var my_name: String = "Weapon"
@export var type: TYPE = TYPE.SEMI_AUTO
@export var ammo_type: AMMO = AMMO.BULLET
@export var fire_rate: float = 1.0

var shoot_cooldown: float = 0.0
var can_shoot: bool = true

# TODO: rearrange order of fire() and its overrides to prevent shooting when can_shoot is false

func fire() -> void:
	pass

func _process(delta: float) -> void:
	if shoot_cooldown > 0:
		shoot_cooldown -= delta

	if shoot_cooldown <= 0:
		can_shoot = true


func trigger():
	shoot_cooldown = fire_rate
	can_shoot = false
