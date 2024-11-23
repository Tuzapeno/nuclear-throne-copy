class_name BanditGun
extends Node2D

@export var sprite: Sprite2D

var bandit_bullet: PackedScene = preload("res://Scenes/bandit_bullet.tscn")
var direction: Vector2 = Vector2.RIGHT
var damage: int = 1
var parent: Node2D = null

func _ready() -> void:
	parent = get_parent() as Node2D

func aim(target: Vector2) -> void:
	direction = (target - global_position).normalized()
	rotation = direction.angle()

	if target.x < global_position.x:
		sprite.flip_v = true
	elif target.x > global_position.x:
		sprite.flip_v = false

	if target.y < global_position.y:
		z_index = parent.z_index - 1
	elif target.y > global_position.y:
		z_index = parent.z_index + 1

func fire() -> void:
	var bullet: EnemyProjectile = create_bullet()
	bullet.direction = Vector2.RIGHT.rotated(direction.angle())
	
func get_tip_position() -> Vector2:
	return global_position + (sprite.texture.get_width()/2) * direction.normalized()

func create_bullet() -> Object:
	var bullet: EnemyProjectile = bandit_bullet.instantiate()
	parent.add_sibling(bullet)
	bullet.global_position = get_tip_position() # Fixes bullets disappearing when bandit is killed (TEMPORARY FIX) switch to Globals.world.add_child
	bullet.enemyEntity = parent
	return bullet

