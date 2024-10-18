class_name Weapon
extends Node2D

# TODO: Use RESOURCES for storing weapon data.

enum TYPE { SEMI_AUTO, FULL_AUTO, BURST }

@export var my_name: String = "Weapon"
@export var type: int = TYPE.SEMI_AUTO
@export var ammo_type: int = AmmoTypes.BULLET_TYPE
@export var fire_rate: float = 1.0
@export var fire_cost: int = 1

@onready var sprite: Sprite2D = $Sprite2D

var shoot_cooldown: float = 0.0
var can_shoot: bool = true
var is_primary: bool = false
var facing_right: bool = true
var base_z_index = z_index

func fire() -> void:
    AmmoManager.spend_ammo(ammo_type, fire_cost)
    trigger()

func can_fire() -> bool:
    if not can_shoot:
        return false

    if not AmmoManager.has_ammo(ammo_type, fire_cost):
        print(my_name + " is out of ammo!")
        return false

    return true


func _process(delta: float) -> void:
    # Update shoot cooldown
    if shoot_cooldown > 0:
        shoot_cooldown -= delta
        if shoot_cooldown <= 0:
            can_shoot = true

    var mouse_pos: Vector2 = get_global_mouse_position()

    # Determine if the weapon is facing right
    facing_right = global_position.x < mouse_pos.x

    # Rotate and flip weapon sprite
    if is_primary:
        sprite.rotation = (mouse_pos - global_position).angle()
        sprite.flip_v = not facing_right
    else:
        sprite.flip_v = not facing_right

    

# TODO: add functions so instead of player modifying the weapon,
# the player only calls the weapon functions
func trigger() -> void:
    shoot_cooldown = fire_rate
    can_shoot = false

func unset_offset() -> void:
    sprite.offset = Vector2()

func make_primary() -> void:
    is_primary = true
    sprite.offset = Vector2(sprite.texture.get_width() * 0.3, 0)  # Offset it a bit to front
    z_index = base_z_index + 1  # Make it render in front of player

func make_extra() -> void:
    # Reset position to back of character
    position = Vector2(0, 0)
    is_primary = false

    sprite.rotation = Vector2.UP.angle() # Rotate weapon to face upwards
    z_index = base_z_index - 1  # Render behind the player


func get_tip_position() -> Vector2:
    return global_position + sprite.offset.rotated(sprite.rotation)

