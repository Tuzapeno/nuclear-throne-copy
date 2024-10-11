extends CharacterBody2D

# Ammo class to manage bullet count
class Ammo:
    var bullet: int = 0

# Variables
@export var speed: float = 150.0  # Player speed

@onready var animsprite2D = $AnimatedSprite2D  # Reference to AnimatedSprite2D node

var weapon_primary: Weapon = null
var weapon_extra: Weapon = null
var ammo: Ammo = Ammo.new()  # Initialize ammo and inventory

# Constructor: Set global reference to this player
func _init() -> void:
    print("Estou sendo iniciado!!!")
    Globals.player = self
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

    var direction: Vector2 = get_global_mouse_position() - global_position
    animsprite2D.flip_h = direction.x < 0

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
    
    add_child(weapon)

    # TODO: Remove from here, add so when the player aims upwards the weapon is shown in the back

    # TODO: See how to manage all Z-indexes

    # TODO: Starting weapon breaks the game if scene is changed using U

    # TODO: Machinegun is crashing when picked up

    weapon.z_index = 1
    z_index = 0

    if weapon_primary == null:
        weapon_primary = weapon
        weapon_primary.show()
    elif weapon_extra == null:
        weapon_extra = weapon
        weapon_extra.hide()
    else:
        drop_primary_weapon()
        weapon_primary = weapon
        weapon_primary.show()

    # TODO: show the extra weapon in character's back

# Drop the primary weapon and set the new one
func drop_primary_weapon() -> void:
    var drop_scene: PackedScene = load(Globals.weapon_drop_scene_path + weapon_primary.my_name.to_lower() + "_drop.tscn")
    var drop: WeaponDrop = drop_scene.instantiate()
    drop.position = Globals.player.global_position
    get_tree().root.add_child(drop)
    weapon_primary.queue_free()

# Swap between primary and extra weapon
func swap_weapons() -> void:
    if weapon_extra == null:
        return

    var temp = weapon_primary
    weapon_primary = weapon_extra
    weapon_extra = temp
    weapon_primary.show()
    weapon_extra.hide()