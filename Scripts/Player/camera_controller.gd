extends Camera2D

const MAX_ZOOM: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set camera properties
	#zoom = Vector2(4, 4)
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
