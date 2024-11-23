extends BanditGun

var n_bullets: int = 16
var fire_delay: float = 0.05
var bullet_deviation: float = 0.4

func fire() -> void:
	for i in range(n_bullets):
		var bullet: EnemyProjectile = create_bullet()
		bullet.direction = Vector2.RIGHT.rotated(direction.angle() + randf_range(-bullet_deviation, bullet_deviation))
		await get_tree().create_timer(fire_delay).timeout