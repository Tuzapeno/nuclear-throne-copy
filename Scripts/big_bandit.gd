extends CharacterBody2D


# A cada 2 segundos
	# Se o player está na linha de visão (raycast não tiver nada entre o bandit e o player)
		# Aponta e Metralha
	# Senão
		# dasha em direção ao player quebrando as paredes que entrarem em contato com ele

enum STATE { IDLE, SHOOTING, DASHING }

@export var speed: float = 100
@export var health: float = 50
@export var sight: RayCast2D
@export var state_label: Label
@export var gun: BanditGun
@export var animation: AnimatedSprite2D

const WAIT_TIME = 2

var current_state: STATE = STATE.IDLE :
	set(state):
		current_state = state
		if state == STATE.IDLE:
			is_idling = false
			animation.play("idle")
			state_label.text = "IDLE"
		if state == STATE.SHOOTING:
			is_shooting = false
			state_label.text = "SHOOTING"
			animation.play("shooting")
		if state == STATE.DASHING:
			state_label.text = "DASHING"
			animation.play("dashing")

var player_in_sight: bool = false
var direction: Vector2
var target_position: Vector2
var level: Node2D
var is_idling: bool = false
var is_shooting: bool = false

func _on_action_timer_timeout() -> void:
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

	if collision:
		collider = collision.get_collider()

	if collider:
		if collider.name == "Player":
			Globals.player.get_damage(10)
			dash_stop()

		if collider.name == "TileMapLayer":
			var tile_pos = level.tm_layer.get_coords_for_body_rid(collision.get_collider_rid())
			if level.has_method("destroy_tile"):
				level.destroy_tile(tile_pos)

	if target_position.distance_to(global_position) < 10:
		dash_stop()

func dash_stop() -> void:
	animation.play("dash_stop")
	await animation.animation_finished
	current_state = STATE.IDLE

func get_damage(damage: float) -> void:
	if animation.animation == "hit" and animation.is_playing():
		animation.stop()
		animation.play("hit")
	else:
		animation.play("hit")
		
	health -= damage
	if health <= 0:
		queue_free()

