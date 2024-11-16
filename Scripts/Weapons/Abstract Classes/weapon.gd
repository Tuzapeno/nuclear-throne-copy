class_name Weapon
extends Node2D

enum TYPE { SINGLE, AUTO, BURST }

@export var resource: Resource = null

@onready var sprite: Sprite2D = $Sprite2D

var shoot_cooldown: float = 0.0
var can_shoot: bool = true
var is_primary: bool = false
var facing_right: bool = true
var base_z_index = z_index

func fire() -> void:
    pass

func can_fire() -> bool:
    if not can_shoot:
        return false

    if not AmmoManager.has_ammo(resource.ammo_type, resource.fire_cost):
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
    if not can_fire():
        return

    var dir = (get_tip_position() - global_position).normalized()
    Globals.camera.shake_offset(-dir.x * resource.kickback, -dir.y * resource.kickback)

    shoot_cooldown = resource.fire_rate
    can_shoot = false
    AmmoManager.spend_ammo(resource.ammo_type, resource.fire_cost)

    fire()

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
    return global_position + (sprite.texture.get_width() * Vector2(1, 0)).rotated(sprite.rotation)
    #eturn global_position

func get_type() -> TYPE:
    return resource.type
