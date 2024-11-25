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
var is_dying: bool = false
var knockback_vector: Vector2 = Vector2.ZERO
var base_velocity: Vector2 = Vector2.ZERO

func _on_walk_timer_timeout():
	var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	distance_to_walk = randf_range(speed, speed*2)
	base_velocity = direction * speed
	moving = true

func _on_shoot_timer_timeout():
	weapon.fire()

func _on_aim_timer_timeout():
	if Globals.player != null:
		weapon.aim(Globals.player.global_position)

func _ready():
	walk_timer.start(randi_range(2, 3))

func _process(_delta):
	move_and_slide()
	handle_animation()

	velocity = base_velocity + knockback_vector

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
		set_process(false)

	# Walk logic
	if distance_walked >= distance_to_walk and moving:
		stop_moving()
	else:
		distance_walked += velocity.length() * _delta

	if knockback_vector.length() > 0:
		knockback_vector = knockback_vector.move_toward(Vector2.ZERO, 1000 * _delta)

func handle_animation():
	if animation_sprite.animation == "hit" and animation_sprite.is_playing():
		return
	elif base_velocity.length() > 0:
		animation_sprite.play("run")
	else:
		animation_sprite.play("idle")

	if velocity.x < 0:
		animation_sprite.flip_h = true
	elif velocity.x > 0:
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

	if animation_sprite.animation == "hit" and animation_sprite.is_playing():
		animation_sprite.stop()
		animation_sprite.play("hit")
	else:
		animation_sprite.play("hit")

	health -= value
	if health <= 0:
		return true
	return false

func die() -> void:
	died.emit(100)
	animation_sprite.play("die")
	drop_item()
	disable_entity()


func drop_item() -> void:
	if AmmoManager.ammo_drop_chance():
		var ammo_drop = ammo_drop_scene.instantiate()
		ammo_drop.global_position = global_position
		add_sibling(ammo_drop)

	if AmmoManager.health_drop_chance():
		var health_drop = Globals.health_drop_scene.instantiate()
		health_drop.global_position = global_position
		add_sibling(health_drop)

func disable_entity() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	shoot_timer.stop()
	aim_timer.stop()
	weapon.queue_free()
	set_collision_layer_value(1, 0)
	set_collision_mask_value(1, 0)