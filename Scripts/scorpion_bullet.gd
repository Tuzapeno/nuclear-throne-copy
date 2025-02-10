class_name ScorpionBullet
extends EnemyProjectile

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	super()
	speed = 100

func _physics_process(delta: float) -> void:
	super(delta)

func this_signal(body: Node2D) -> void:
	if body is Bandit or body is BigBandit or body is Scorpion:
		return
	if body.has_method("get_damage"):
		var killed: bool = body.get_damage(damage)
		if killed:
			SignalBus.player_killed_by.emit(enemyEntity)
	vanish()


func vanish() -> void:
	speed = 0
	anim.play("vanish")
	await anim.animation_finished
	queue_free()