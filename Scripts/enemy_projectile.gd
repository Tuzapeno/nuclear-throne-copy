class_name EnemyProjectile
extends Area2D

const SPEED = 150
var damage: int = 1
var direction := Vector2.RIGHT
var enemyEntity: Node2D = null

func _on_body_entered(body: Node2D) -> void:
	if body is Bandit or body is BigBandit:
		return
	if body.has_method("get_damage"):
		var killed: bool = body.get_damage(damage)
		if killed:
			SignalBus.player_killed_by.emit(enemyEntity)
	queue_free()

func _ready() -> void:
	# Rotate the bullet to face the direction it is moving
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	global_position += direction * SPEED * delta
