extends Camera2D

enum CameraState { PLAYER, FREE, LOCKED }

const MAX_ZOOM: int = 100

@export var default_shake_strength: float = 30.0
@export var shake_fade: float = 5.0

var shake_strength: float = 0.0
var target: Node2D = null
var current_camera_state: CameraState = CameraState.PLAYER

func _ready() -> void:
	global_position = target.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_camera_state:
		# Camera free roam
		CameraState.FREE:
			camera_free(delta)
		# Camera locked to an entity and follows it
		CameraState.LOCKED:
			camera_locked()

	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, delta * shake_fade)
		offset = shake_random_offset()
	else:
		if offset != Vector2.ZERO:
			offset = lerp(offset, Vector2.ZERO, delta * shake_fade)

func apply_shake(value: float = default_shake_strength) -> void:
	shake_strength = value

func shake_random_offset() -> Vector2:
	return Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	
func camera_free(delta) -> void:
	if Input.is_action_pressed("ui_up"):
		position.y -= 200 * delta
	if Input.is_action_pressed("ui_down"):
		position.y += 200 * delta
	if Input.is_action_pressed("ui_left"):
		position.x -= 200 * delta
	if Input.is_action_pressed("ui_right"):
		position.x += 200 * delta

func camera_locked():
	if target == null:
		return
	global_position = lerp(global_position, target.global_position, 0.2)

func set_target(_target: Node2D):
	target = _target
	current_camera_state = CameraState.LOCKED

func is_locked() -> bool:
	return current_camera_state == CameraState.LOCKED

func set_free() -> void:
	current_camera_state = CameraState.FREE

func set_locked() -> void:
	current_camera_state = CameraState.LOCKED

func shake_offset(x: float, y: float) -> void:
	offset.x = x
	offset.y = y
	