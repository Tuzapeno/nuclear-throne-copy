extends CharacterBody2D

@onready var animsprite2D = $AnimatedSprite2D


const SPEED: float = 300.0


func _physics_process(_delta: float) -> void:
	
  var movement: Vector2 = Vector2()
  movement.x = Input.get_axis("move_left", "move_right")
  movement.y = Input.get_axis("move_up", "move_down")

  movement = movement.normalized()

  velocity = movement * SPEED
  
  handle_animations()
  move_and_slide()


func handle_animations() -> void:
  if velocity.length() > 0:
    animsprite2D.play("walk")
  else:
    animsprite2D.play("idle")
