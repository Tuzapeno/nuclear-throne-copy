extends CharacterBody2D

# Variables
@export var speed: float = 150.0  # Player speed

# Nodes
@onready var animsprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var camera: Camera2D = $Camera2D



var weapon_primary: Weapon = null :
    set(weapon):
        weapon_primary = weapon
        weapon_primary.make_primary()


var weapon_extra: Weapon = null :
    set(weapon):
        weapon_extra = weapon
        weapon_extra.make_extra()

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

func pickup_weapon(weapon: Weapon) -> void:

    # TODO: Add so the player only picks up one weapon if two weapons are overlapped.
    add_child(weapon)

    # Add a little y offset to look like the weapon is in the player hand
    # TODO: need to move this elsewhere
    weapon.position.y += 3

    if weapon_primary == null:
        weapon_primary = weapon
    elif weapon_extra == null:
        weapon_extra = weapon
    else:
        drop_primary_weapon()
        weapon_primary = weapon

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
