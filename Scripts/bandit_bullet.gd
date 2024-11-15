class_name BanditBullet
extends EnemyProjectile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	parent = get_parent()

func _physics_process(delta: float) -> void:
	super(delta)
