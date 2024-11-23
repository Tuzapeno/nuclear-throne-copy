extends CharacterBody2D


# A cada 2 segundos
	# Se o player está na linha de visão (raycast não tiver nada entre o bandit e o player)
		# Aponta e Metralha
	# Senão
		# dasha em direção ao player quebrando as paredes que entrarem em contato com ele

enum STATE { IDLE, SHOOTING, DASHING }

@export var speed: float = 100
@export var health: int = 100
@export var sight: RayCast2D
@export var state_label: Label
@export var sight_label: Label

const WAIT_TIME = 2

var current_state: STATE = STATE.IDLE :
	set(state):
		current_state = state
		if state == STATE.IDLE:
			is_idling = false

var player_in_sight: bool = false
var direction: Vector2
var target_position: Vector2
var level: Node2D
var is_idling: bool = false

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
			#sight_label.text = "PLAYER IN SIGHT"
		else:
			player_in_sight = false
			#sight_label.text = "PLAYER OUT OF SIGHT"

func idle() -> void:
	if not is_idling:
		is_idling = true
		state_label.text = "IDLE"
		var timer = get_tree().create_timer(WAIT_TIME)
		timer.timeout.connect(_on_action_timer_timeout)
		await timer.timeout

func shooting() -> void:
	state_label.text = "SHOOTING"
	await get_tree().create_timer(1).timeout
	current_state = STATE.IDLE

func dashing(delta) -> void:
	state_label.text = "DASHING"
	var collision = move_and_collide(direction * speed * delta)
	var collider: Node2D = null

	if collision:
		collider = collision.get_collider()

	if collider:
		sight_label.text = collider.name

		if collider.name == "Player":
			Globals.player.get_damage(10)
			current_state = STATE.IDLE

		if collider.name == "TileMapLayer":
			print("TILE POSITION: ", collider.global_position)
			var tile_pos = level.tm_layer.get_coords_for_body_rid(collision.get_collider_rid())
			if level.has_method("destroy_tile"):
				level.destroy_tile(tile_pos)
				print("TILE DESTRUIDO!")

	if target_position.distance_to(global_position) < 10:
		current_state = STATE.IDLE
