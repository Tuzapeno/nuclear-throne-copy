class_name Bandit
extends CharacterBody2D

signal died

var ammo_drop_scene: PackedScene = preload("res://Scenes/ammo_drop.tscn")

@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var walk_timer: Timer = $WalkTimer
@onready var shoot_timer: Timer = $ShootTimer
@onready var aim_timer: Timer = $AimTimer

@onready var weapon: BanditGun = $BanditGun

const shoot_time: float = 2.5
const aim_time: float = 2.0

var target_position = Vector2.ZERO
var speed = 50
var stop_distance = 5
var moving = false
var distante_to_player: float = 0

var distance_to_walk: float = 0
var distance_walked: float = 0

var health: float = 2

func _on_walk_timer_timeout():
	var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	distance_to_walk = randf_range(speed, speed*2)
	velocity = direction * speed
	moving = true

func _on_shoot_timer_timeout():
	weapon.fire()

func _on_aim_timer_timeout():
	if Globals.player != null:
		weapon.aim(Globals.player.global_position)

func _ready():
	walk_timer.start(randi_range(2, 3))

func _process(_delta):
	handle_animation()
	move_and_slide()

	if Globals.player != null:
		distante_to_player = global_position.distance_to(Globals.player.global_position)

		if distante_to_player <= 150:
			if shoot_timer.is_stopped():
				shoot_timer.start(shoot_time)
			if aim_timer.is_stopped():
				aim_timer.start(aim_time)
		else:
			shoot_timer.stop()
			aim_timer.stop()

	if health <= 0:
		die()

	# Walk logic
	if distance_walked >= distance_to_walk and moving:
		stop_moving()
	else:
		distance_walked += velocity.length() * _delta

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
	velocity = Vector2.ZERO
	walk_timer.start(randi_range(2, 3))
	moving = false
	distance_walked = 0

# Returns if kills instance
func get_damage(value: float) -> bool:
	health -= value
	if health <= 0:
		return true
	return false

func die() -> void:
	died.emit()
	drop_item()
	queue_free()

func drop_item() -> void:
	if AmmoManager.ammo_drop_chance():
		var ammo_drop = ammo_drop_scene.instantiate()
		ammo_drop.global_position = global_position
		add_sibling(ammo_drop)