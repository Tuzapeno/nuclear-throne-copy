class_name Shell
extends Area2D

const SPEED = 50

var direction := Vector2.RIGHT

func _ready() -> void:
	# Rotate the bullet to face the direction it is moving
	rotation = direction.angle()

func _process(delta: float) -> void:
	global_position += direction * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body == Globals.player: # Player ignores its own bullets
		return
	queue_free()