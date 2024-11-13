extends Camera2D

const MAX_ZOOM: int = 100

@export var default_shake_strength: float = 30.0
@export var shake_fade: float = 5.0

var shake_strength: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouse_position := get_local_mouse_position()	

	# Clamp the mouse position
	if mouse_position.length() > MAX_ZOOM:
		mouse_position = mouse_position.normalized() * MAX_ZOOM

	# Calculate and set the new camera position
	var camera_pos = lerp(position, mouse_position/2, 0.2)
	position = camera_pos

	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, _delta * shake_fade)
		offset = shake_random_offset()
	else:
		if offset != Vector2.ZERO:
			offset = lerp(offset, Vector2.ZERO, _delta * shake_fade)

func apply_shake(value: float = default_shake_strength) -> void:
	shake_strength = value

func shake_random_offset() -> Vector2:
	return Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	