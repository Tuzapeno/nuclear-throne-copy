class_name Bandit
extends CharacterBody2D

signal died

@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var walk_timer: Timer = $WalkTimer
@onready var stop_timer: Timer = $StopTimer
@onready var shoot_timer: Timer = $ShootTimer
@onready var aim_timer: Timer = $AimTimer

@onready var weapon: BanditGun = $BanditGun

var target_position = Vector2.ZERO
var speed = 50
var stop_distance = 5
var moving_lock = false
var distante_to_player: float = 0

var health: float = 2

func _on_walk_timer_timeout():
	var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var distance = randi_range(25, 50)
	target_position = global_position + direction * distance
	velocity = (target_position - global_position).normalized() * speed

func _on_stop_timer_timeout():
	stop_moving()

func _on_ShootTimer_timeout():
	weapon.fire()

func _on_AimTimer_timeout():
	if Globals.player != null:
		weapon.aim(Globals.player.global_position)

func _ready():
	stop_timer.connect(stop_timer.timeout.get_name(), _on_stop_timer_timeout)
	walk_timer.connect(walk_timer.timeout.get_name(), _on_walk_timer_timeout)
	shoot_timer.connect(shoot_timer.timeout.get_name(), _on_ShootTimer_timeout)
	aim_timer.connect(aim_timer.timeout.get_name(), _on_AimTimer_timeout)
	walk_timer.start(randi_range(2, 3))

func _process(_delta):
	handle_animation()
	move_and_slide()

	if Globals.player != null:
		distante_to_player = global_position.distance_to(Globals.player.global_position)

	if health <= 0:
		died.emit()
		queue_free()

	if position.distance_to(target_position) < stop_distance:
		stop_moving()
	elif stop_timer.is_stopped() and not moving_lock:
		stop_timer.start(4)
		moving_lock = true

	if distante_to_player <= 150:
		if shoot_timer.is_stopped():
			shoot_timer.start(1)
		if aim_timer.is_stopped():
			aim_timer.start(0.5)
	else:
		shoot_timer.stop()
		aim_timer.stop()


func handle_animation():
	if velocity.length() > 0:
		animation_sprite.play("run")
	else:
		animation_sprite.play("idle")

	if velocity.x < 0:
		animation_sprite.flip_h = true
	elif velocity.x > 0:
		animation_sprite.flip_h = false


func stop_moving():
	if not stop_timer.is_stopped():
		stop_timer.stop()

	velocity = Vector2.ZERO
	walk_timer.start(randi_range(2, 3))
	moving_lock = false

# Returns if kills instance
func get_damage(value: float) -> bool:
	health -= value
	if health <= 0:
		return true
	return false