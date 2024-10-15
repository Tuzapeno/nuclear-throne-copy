extends CharacterBody2D

# Ammo class to manage bullet count
class Ammo:
    var bullet: int = 0

# Variables
@export var speed: float = 150.0  # Player speed

@onready var animsprite2D: AnimatedSprite2D = $AnimatedSprite2D  # Reference to AnimatedSprite2D node
@onready var sprite: Sprite2D = $Sprite2D  # Reference to Sprite2D node
@onready var camera: Camera2D = $Camera2D  # Reference to Camera2D node

var weapon_primary: Weapon = null :
    set(weapon):
        weapon_primary = weapon
        weapon_primary.make_primary()


var weapon_extra: Weapon = null :
    set(weapon):
        weapon_extra = weapon
        weapon_extra.make_extra()




var ammo: Ammo = Ammo.new()  # Initialize ammo and inventory

var is_first_spawn: bool = true

# Constructor: Set global reference to this player
func _init() -> void:
    print("Estou sendo iniciado!!!")
    Globals.player = self


func _ready() -> void:
    if is_first_spawn:
        is_first_spawn = false
        pickup_weapon(Globals.starting_weapon)


# Physics process: Handle movement and physics
func _physics_process(_delta: float) -> void:
    handle_movement()
    move_and_slide()

# Process: Handle animations, facing direction, and weapon logic
func _process(_delta: float) -> void:
    handle_animations()
    handle_weapon()
    handle_camera()

# Handle player movement
func handle_movement() -> void:
    var movement: Vector2 = Vector2()
    movement.x = Input.get_axis("move_left", "move_right")
    movement.y = Input.get_axis("move_up", "move_down")
    movement = movement.normalized()
    velocity = movement * speed

# Handle player animations
func handle_animations() -> void:
    if velocity.length() > 0:
        animsprite2D.play("walk")
    else:
        animsprite2D.play("idle")

    # Flip character
    var direction: Vector2 = get_global_mouse_position() - global_position

    var flip: bool = direction.x < 0

    animsprite2D.flip_h = flip
    #weapon.flip_h = flip


    # Make gun go behind the player when aiming upwards
    if direction.y < 0 and weapon_primary != null:
        weapon_primary.z_index = z_index - 1
    else:
        weapon_primary.z_index = z_index + 1




# Handle weapon actions (firing, swapping)
func handle_weapon() -> void:
    if weapon_primary == null:
        return

    if Input.is_action_just_pressed("swap_weapons"):
        swap_weapons()

    if Input.is_action_just_pressed("use"):
        # Debug print of current weapons
        if weapon_primary != null:
            print("Weapon: ", weapon_primary.my_name)
        if weapon_extra != null:
            print("Extra Weapon: ", weapon_extra.my_name)


    # Handle weapon firing based on weapon type
    match weapon_primary.type:
        Weapon.TYPE.SEMI_AUTO:
            if Input.is_action_just_pressed("fire"):
                weapon_primary.fire()
        Weapon.TYPE.FULL_AUTO:
            if Input.is_action_pressed("fire"):
                weapon_primary.fire()


func handle_camera() -> void:

    # TODO: Move all of this to camera node code.

    var MAX_ZOOM := 50

    var mouse_position := get_local_mouse_position()

    mouse_position = Utils.clamp_vector(mouse_position, -MAX_ZOOM, MAX_ZOOM)

    var camera_pos = lerp(camera.position, mouse_position/2, 0.2)

    camera.position = camera_pos


func pickup_weapon(weapon: Weapon) -> void:

    # TODO: Add so overlaying weapons pickup doesn`t break the game
    add_child(weapon)

    if weapon_primary == null:
        weapon_primary = weapon
    elif weapon_extra == null:
        weapon_extra = weapon
    else:
        drop_primary_weapon()
        weapon_primary = weapon


    # TODO: show the extra weapon in character's back

# Drop the primary weapon and set the new one
func drop_primary_weapon() -> void:
    var drop_scene: PackedScene = load(Globals.weapon_drop_scene_path + weapon_primary.my_name.to_lower() + "_drop.tscn")
    var drop: WeaponDrop = drop_scene.instantiate()
    drop.position = Globals.player.global_position
    remove_child(weapon_primary)
    get_tree().root.add_child(drop)
    weapon_primary.queue_free()

# Swap between primary and extra weapon
func swap_weapons() -> void:
    if weapon_extra == null:
        return

    var temp = weapon_primary
    weapon_primary = weapon_extra
    weapon_extra = temp
