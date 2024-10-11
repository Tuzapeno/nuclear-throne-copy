class_name Weapon
extends Node2D

# TODO: Use RESOURCES for storing weapon data.

enum TYPE { SEMI_AUTO, FULL_AUTO, BURST }
enum AMMO { BULLET, SHELL }

@export var my_name: String = "Weapon"
@export var type: TYPE = TYPE.SEMI_AUTO
@export var ammo_type: AMMO = AMMO.BULLET
@export var fire_rate: float = 1.0

@onready var sprite: Sprite2D = $Sprite2D

var shoot_cooldown: float = 0.0
var can_shoot: bool = true
var is_primary: bool = false
var facing_right: bool = true

func fire() -> void:
	pass

func _process(delta: float) -> void:
	if shoot_cooldown > 0:
		shoot_cooldown -= delta

	if shoot_cooldown <= 0:
		can_shoot = true

	var mouse_pos: Vector2 = get_global_mouse_position()

	# TODO: need to find a better way to do this
	
	facing_right = global_position.x < mouse_pos.x

	# Primary weapon should aim towards mouse
	if is_primary:
		# Rotate weapon towards mouse
		sprite.rotation = (mouse_pos - global_position).angle()
		# Flip weapon sprite
		sprite.flip_v = not facing_right
	# Extra weapon should stay behind the player
	else:
		if facing_right:
			sprite.rotation = Vector2.UP.angle() - deg_to_rad(30)
		else:
			sprite.rotation = Vector2.UP.angle() + deg_to_rad(30)
	


func trigger() -> void:
	shoot_cooldown = fire_rate
	can_shoot = false

func unset_offset() -> void:
	sprite.offset = Vector2()
