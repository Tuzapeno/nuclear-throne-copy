class_name Scorpion
extends CharacterBody2D

signal died

enum STATE { SHOOTING, IDLE, WALKING }

var ammo_drop_scene: PackedScene = preload("res://Scenes/ammo_drop.tscn")

var stinger_scene: PackedScene = preload("res://Scenes/scorpion_bullet.tscn")

@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var walk_timer: Timer = $WalkTimer
@onready var shoot_timer: Timer = $ShootTimer

const shoot_time: float = 2.5

var target_position = Vector2.ZERO
var speed = 50
var stop_distance = 5
var moving = false
var distante_to_player: float = 0

var distance_to_walk: float = 0
var distance_walked: float = 0

var direction: Vector2 = Vector2.ZERO
var health: float = 10
var is_dying: bool = false
var knockback_vector: Vector2 = Vector2.ZERO
var base_velocity: Vector2 = Vector2.ZERO

var current_state: STATE = STATE.IDLE

func _on_walk_timer_timeout():
	var _direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	distance_to_walk = randf_range(speed, speed*2)
	base_velocity = _direction * speed
	moving = true

func _on_shoot_timer_timeout():
	fire()

func _ready():
	walk_timer.start(randi_range(2, 3))

func _process(_delta):
	move_and_slide()
	handle_animation()
	direction = (Globals.player.global_position - global_position).normalized()

	velocity = base_velocity + knockback_vector

	if Globals.player != null:
		distante_to_player = global_position.distance_to(Globals.player.global_position)

		if distante_to_player <= 150:
			if shoot_timer.is_stopped():
				shoot_timer.start(shoot_time)
		else:
			shoot_timer.stop()

	if health <= 0:
		die()
		set_process(false)

	# Walk logic
	if distance_walked >= distance_to_walk and moving:
		stop_moving()
	else:
		distance_walked += velocity.length() * _delta

	if knockback_vector.length() > 0:
		knockback_vector = knockback_vector.move_toward(Vector2.ZERO, 1000 * _delta)

func handle_animation():
	if animation_sprite.animation == "hurt" and animation_sprite.is_playing():
		return

	if current_state == STATE.SHOOTING:
		animation_sprite.play("shoot")
	elif current_state == STATE.IDLE:
		animation_sprite.play("idle")
	elif current_state == STATE.WALKING:
		animation_sprite.play("walk")

	if current_state != STATE.SHOOTING:
		if base_velocity.length() > 0:
			current_state = STATE.WALKING
		else:
			current_state = STATE.IDLE

	if Globals.player.global_position.x < global_position.x:
		animation_sprite.flip_h = true
	elif Globals.player.global_position.x > global_position.x:
		animation_sprite.flip_h = false


func stop_moving():
	base_velocity = Vector2.ZERO
	walk_timer.start(randi_range(2, 3))
	moving = false
	distance_walked = 0

# Returns if kills instance
func get_damage(value: float) -> bool:
	if health <= 0:
		return false

	if animation_sprite.animation == "hurt" and animation_sprite.is_playing():
		animation_sprite.stop()
		animation_sprite.play("hurt")
	else:
		animation_sprite.play("hurt")

	health -= value
	if health <= 0:
		return true
	return false

func die() -> void:
	died.emit()
	animation_sprite.play("die")
	drop_item()
	disable_entity()


func drop_item() -> void:
	if AmmoManager.ammo_drop_chance():
		var ammo_drop = ammo_drop_scene.instantiate()
		ammo_drop.global_position = global_position
		add_sibling(ammo_drop)

	if randf() < (1 - (Globals.player.health / Globals.player.max_health)) * 0.25:
		var health_drop = Globals.health_drop_scene.instantiate()
		health_drop.global_position = global_position
		add_sibling(health_drop)

func disable_entity() -> void:
	shoot_timer.stop()
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	set_collision_layer_value(1, 0)
	set_collision_mask_value(1, 0)

func fire() -> void:
	current_state = STATE.SHOOTING
	for i in range(16):
		var stinger = create_stinger()
		await get_tree().create_timer(randf_range(0.025, 0.05)).timeout
	current_state = STATE.IDLE

func create_stinger() -> ScorpionBullet:
	var stinger = stinger_scene.instantiate()
	stinger.global_position = global_position
	stinger.direction = Vector2.RIGHT.rotated(direction.angle() + randf_range(-0.5, 0.5))
	stinger.enemyEntity = self
	add_sibling(stinger)
	return stinger
