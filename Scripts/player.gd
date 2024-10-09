extends CharacterBody2D

class Ammo:
  var bullet: int = 0

class Inventory:
  var weapon_primary: Weapon = null
  var weapon_extra: Weapon = null

  func switch_weapon() -> void:
    var temp = weapon_primary
    weapon_primary = weapon_extra
    weapon_extra = temp

  func pickup_weapon(weapon: Weapon) -> void:
    if weapon_primary == null:
      weapon_primary = weapon
    elif weapon_extra == null:
      weapon_extra = weapon
    else:
      weapon_primary = weapon
      # TODO: Drop old weapon_primary

    



@export var speed: float = 150.0

@onready var animsprite2D = $AnimatedSprite2D

var ammo: Ammo = Ammo.new()
var inventory: Inventory = Inventory.new()
 
func _init() -> void:
  Globals.player = self

func _physics_process(_delta: float) -> void:
  handle_movement()
  move_and_slide()

func _process(_delta: float) -> void:
  handle_animations()
  face_mouse_direction()


func handle_animations() -> void:
  if velocity.length() > 0:
    animsprite2D.play("walk")
  else:
    animsprite2D.play("idle")

func face_mouse_direction() -> void:
  var direction: Vector2 = get_global_mouse_position() - global_position
  $AnimatedSprite2D.flip_h = direction.x < 0

func handle_movement() -> void:
  var movement: Vector2 = Vector2()
  movement.x = Input.get_axis("move_left", "move_right")
  movement.y = Input.get_axis("move_up", "move_down")

  movement = movement.normalized()

  velocity = movement * speed