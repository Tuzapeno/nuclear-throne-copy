class_name ItemDrop
extends Area2D

var pulling: bool = false
var pull_speed: float = 200
var distance_threshold: float = 10

func _ready() -> void:
	var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	global_position += direction * 5

func pickup_action() -> void:
	pass

func pull() -> void:
	pulling = true

func _process(delta: float) -> void:
	if not pulling:
		return

	if not Globals.player:
		return

	var player_pos := Globals.player.global_position

	var direction = (player_pos - global_position).normalized()
	global_position += direction * pull_speed * delta

	if global_position.distance_to(player_pos) < distance_threshold:
		pulling = false
		pickup_action()
		queue_free()
