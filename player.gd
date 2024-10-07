extends CharacterBody2D


const SPEED: float = 300.0


func _physics_process(_delta: float) -> void:
	
  var movement: Vector2 = Vector2()
  movement.x = Input.get_axis("ui_left", "ui_right")
  movement.y = Input.get_axis("ui_up", "ui_down")

  movement = movement.normalized()

  velocity = movement * SPEED
  
  move_and_slide()
