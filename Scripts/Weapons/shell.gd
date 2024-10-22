class_name Shell
extends Area2D

# Shells deaccelerate over time and then they vanish
# Shells should bounce off walls

# TODO: Bullets sometimes don`t bounce or pass through walls

@onready var raycast := $RayCast2D

const ricochet_loss_percent = 0.5

var speed = 350
var air_resistance = 75
var direction := Vector2.RIGHT

func _ready() -> void:
	rotation = direction.angle()
	
func _physics_process(delta: float) -> void:
	if raycast.is_colliding():
		if raycast.get_collider() is StaticBody2D:
			ricochet(direction, raycast.get_collision_normal())
	global_position += direction * speed * delta

func _process(_delta: float) -> void:
	speed -= air_resistance
	rotation = direction.angle()

	if speed <= 0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body == Globals.player: # Player ignores its own bullets
		return

	# if body is StaticBody2D: # Bounce if it hits a wall
	# 	if raycast.is_colliding():
	# 		ricochet(direction, raycast.get_collision_normal())


func ricochet(_direction: Vector2, _normal: Vector2) -> void:
	direction = -(2 * (_normal * _direction) * _normal - _direction)
	rotation = direction.angle()
	speed *= ricochet_loss_percent
