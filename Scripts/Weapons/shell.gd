class_name Shell
extends Area2D

# Shells deaccelerate over time and then they vanish
# Shells should bounce off walls

# TODO: Bullets sometimes don`t bounce or pass through walls

@export var raycast: RayCast2D
@export var destroy_timer: Timer
@export var sprite: AnimatedSprite2D

const ricochet_loss_percent = 0.5

var speed: float = 300.0
var direction := Vector2.RIGHT
var max_travel_distance = 150
var travel_distance: float = 0.0
var queued_for_destroy: bool = false
var previous_position: Vector2
var friction: float = 1.0

func _ready() -> void:
	rotation = direction.angle()
	destroy_timer.start(max_travel_distance / speed)
	sprite.play("default")

func _physics_process(delta: float) -> void:
	previous_position = global_position
	if raycast.get_collider() is TileMapLayer:
		ricochet(direction, raycast.get_collision_normal())
	global_position += direction * speed * delta
	travel_distance += abs(speed * delta)
	speed = lerp(speed, 0.0, delta * friction)
	if previous_position == global_position:
		destroy()

func _process(_delta: float) -> void:
	rotation = direction.angle()
	if travel_distance >= max_travel_distance:
		destroy()
	
func _on_body_entered(body: Node2D) -> void:
	if body == Globals.player: # Player ignores its own bullets
		return
	if body.has_method("get_damage"):
		body.get_damage(0.5)
		destroy()

func ricochet(_direction: Vector2, _normal: Vector2) -> void:
	direction = -(2 * (_normal * _direction) * _normal - _direction)
	rotation = direction.angle()
	speed *= ricochet_loss_percent

func _on_destroy_timeout() -> void:
	destroy()

# Handles the shell's destruction sequence
# First checks if destruction is already in progress to avoid multiple calls
# Plays the destroy animation and waits for it to finish
# Then removes the shell from the scene
func destroy() -> void:
	if queued_for_destroy:
		return
	queued_for_destroy = true
	sprite.play("destroy")
	await sprite.animation_finished
	queue_free()