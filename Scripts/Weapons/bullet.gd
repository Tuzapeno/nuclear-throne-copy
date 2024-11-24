class_name Bullet
extends Area2D

const SPEED = 500

var direction := Vector2.RIGHT

func _ready() -> void:
	# Rotate the bullet to face the direction it is moving
	rotation = direction.angle()

func _process(delta: float) -> void:
	global_position += direction * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body == Globals.player: # Player ignores its own bullets
		return
	if body.has_method("get_damage"):
		body.get_damage(1)

		if body is Bandit:
			var distance = direction * 5
			var _position = global_position + distance
			var space = get_world_2d().get_direct_space_state()
			var query = PhysicsPointQueryParameters2D.new()
			query.position = _position
			var result = space.intersect_point(query, 1)

			if result.is_empty():
				body.knockback_vector = distance * 50
	queue_free()