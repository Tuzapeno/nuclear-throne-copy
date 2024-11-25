extends CharacterBody2D
class_name BigBandit

# A cada 2 segundos
	# Se o player está na linha de visão (raycast não tiver nada entre o bandit e o player)
		# Aponta e Metralha
	# Senão
		# dasha em direção ao player quebrando as paredes que entrarem em contato com ele

signal died

enum STATE { IDLE, SHOOTING, DASHING, DEAD }

@export var speed: float = 100
@export var health: float = 25
@export var sight: RayCast2D
@export var gun: BanditGun
@export var animation: AnimatedSprite2D

const WAIT_TIME = 2

var current_state: STATE = STATE.IDLE :
	set(state):
		current_state = state
		if dead: return
		if state == STATE.IDLE:
			is_idling = false
			animation.play("idle")
		if state == STATE.SHOOTING:
			is_shooting = false
			animation.play("shooting")
		if state == STATE.DASHING:
			traveled_distance = 0
			animation.play("dashing")

var player_in_sight: bool = false
var direction: Vector2
var target_position: Vector2
var level: Node2D
var is_idling: bool = false
var is_shooting: bool = false
var dead: bool = false
var traveled_distance: float = 0

func _on_action_timer_timeout() -> void:
	if dead:
		return

	check_for_player()

	target_position = Globals.player.global_position
	direction = (target_position - global_position).normalized()

	if player_in_sight:
		current_state = STATE.SHOOTING
	else:
		current_state = STATE.DASHING

func _ready() -> void:
	level = get_parent()

func _process(_delta: float) -> void:
	if not Globals.player:
		return
	
	if Globals.player.global_position.x > global_position.x:
		animation.flip_h = false
	elif Globals.player.global_position.x < global_position.x:
		animation.flip_h = true

	sight.target_position = (Globals.player.global_position - global_position)
	match current_state:
		STATE.IDLE:
			idle()
		STATE.SHOOTING:
			shooting()

func _physics_process(delta: float) -> void:
	match current_state:
		STATE.DASHING:
			dashing(delta)

# Casts a ray and sees if there's something between the bandit and the player
# To decide if the player is in sight
func check_for_player() -> void:
	if Globals.player:
		var body = sight.get_collider()
		if body and body.name == "Player":
			player_in_sight = true
		else:
			player_in_sight = false

func idle() -> void:
	if dead:
		return

	if not is_idling:
		is_idling = true
		var timer = get_tree().create_timer(WAIT_TIME)
		timer.timeout.connect(_on_action_timer_timeout)
		await timer.timeout

func shooting() -> void:
	if not is_shooting:
		if Globals.player:
			gun.aim(Globals.player.global_position)
			gun.fire()
			is_shooting = true
			await get_tree().create_timer(2).timeout
			current_state = STATE.IDLE


func dashing(delta) -> void:
	var collision = move_and_collide(direction * speed * delta)
	var collider: Node2D = null
	traveled_distance += speed * delta

	if collision:
		collider = collision.get_collider()

	if collider:
		if collider.name == "Player":
			var killed: bool = Globals.player.get_damage(10)
			if killed:
				SignalBus.player_killed_by.emit(self)
			dash_stop()

		if collider.name == "TileMapLayer":
			var tile_pos = level.tm_layer.get_coords_for_body_rid(collision.get_collider_rid())
			if level.has_method("destroy_tile"):
				level.destroy_tile(tile_pos)

	if traveled_distance > 400 or global_position.distance_to(target_position) < 10:
		dash_stop()

func dash_stop() -> void:
	animation.play("dash_stop")
	await animation.animation_finished
	current_state = STATE.IDLE

func get_damage(damage: float) -> void:
	if health <= 0:
		return

	if animation.animation == "hit" and animation.is_playing():
		animation.stop()
		animation.play("hit")
	else:
		if current_state != STATE.DASHING: 
			animation.play("hit")
		
	health -= damage
	if health <= 0:
		die()

func die() -> void:
	if not dead:
		died.emit()
		current_state = STATE.DEAD
		animation.stop()
		animation.play("die")
		dead = true
		disable_entity()
		drop_item()

func disable_entity() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	set_collision_layer_value(1, 0)
	set_collision_mask_value(1, 0)
	gun.call_deferred("queue_free")


func drop_item() -> void:
	for i in range(2):
		var ammo_drop = AmmoManager.ammo_drop_scene.instantiate()
		ammo_drop.global_position = global_position
		call_deferred("add_sibling", ammo_drop)
		ammo_drop.z_index = z_index + 5

	for i in range(2):
		var health_drop = Globals.health_drop_scene.instantiate()
		health_drop.global_position = global_position
		call_deferred("add_sibling", health_drop)
		health_drop.z_index = z_index + 5