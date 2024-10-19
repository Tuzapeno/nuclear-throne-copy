class_name Shell
extends Area2D

var speed = 300

# Shells deaccelerate over time and then they vanish
# Shells bounce one time off walls

var air_resistance = 10

var direction := Vector2.RIGHT

func _ready() -> void:
	rotation = direction.angle()

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	speed -= air_resistance
	rotation = direction.angle()

	if speed <= 0:
		queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body == Globals.player: # Player ignores its own bullets
		return

	if body is StaticBody2D: # Bounce if it hits a wall
		direction = bounce(direction)
		return

	
func bounce(_direction: Vector2) -> Vector2:
	return Vector2(-_direction.x, _direction.y)