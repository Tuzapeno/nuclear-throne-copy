class_name BanditGun
extends Node2D

@export var sprite: Sprite2D

var bandit_bullet: PackedScene = preload("res://Scenes/bandit_bullet.tscn")
var direction: Vector2 = Vector2.RIGHT
var damage: int = 1

func aim(target: Vector2) -> void:
	direction = (target - global_position).normalized()
	rotation = direction.angle()

func fire() -> void:
	var bullet: EnemyProjectile = bandit_bullet.instantiate()
	bullet.direction = Vector2.RIGHT.rotated(direction.angle())
	bullet.parent = self
	add_sibling(bullet)
	bullet.global_position = get_tip_position()

func get_tip_position() -> Vector2:
	return global_position + (sprite.texture.get_width()/2) * direction.normalized()

