class_name Bandit
extends CharacterBody2D

signal died

@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var walk_timer: Timer = $WalkTimer
@onready var stop_timer: Timer = $StopTimer

var target_position = Vector2.ZERO
var speed = 20
var stop_distance = 5
var moving_lock = false

var health: float = 2


func _ready():
	stop_timer.connect(stop_timer.timeout.get_name(), _on_stop_timer_timeout)
	walk_timer.connect(walk_timer.timeout.get_name(), _on_walk_timer_timeout)
	walk_timer.start(randi_range(2, 3))

func _process(_delta):
	if health <= 0:
		died.emit()
		queue_free()

	if position.distance_to(target_position) < stop_distance:
		stop_moving()
	elif stop_timer.is_stopped() and not moving_lock:
		stop_timer.start(4)
		moving_lock = true

	handle_animation()
	move_and_slide()

func handle_animation():
	if velocity.length() > 0:
		animation_sprite.play("run")
	else:
		animation_sprite.play("idle")

	if velocity.x < 0:
		animation_sprite.flip_h = true
	elif velocity.x > 0:
		animation_sprite.flip_h = false

func _on_walk_timer_timeout():
	var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var distance = randi_range(25, 50)
	target_position = global_position + direction * distance
	velocity = (target_position - global_position).normalized() * speed

func _on_stop_timer_timeout():
	stop_moving()

func stop_moving():
	if not stop_timer.is_stopped():
		stop_timer.stop()

	velocity = Vector2.ZERO
	walk_timer.start(randi_range(2, 3))
	moving_lock = false

func get_damage(value: float):
	health -= value