extends CharacterBody2D

@export var speed: float = 150.0

@onready var animsprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
  handle_movement()
  handle_animations()
  face_mouse_direction()
  move_and_slide()


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