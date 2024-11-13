class_name Portal
extends Node2D

@onready var portal_sprite: Sprite2D = $Sprite2D
@onready var change_level_timer: Timer = $ChangeLevelTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.player.camera.apply_shake(30)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	portal_sprite.rotation_degrees += 25
	if not Globals.player:
		return
	if Globals.player.global_position.distance_to(global_position) < 50:
		Globals.player.current_state = Globals.player.state.PORTAL
	Globals.player.velocity = ((global_position + Vector2(0, 5)) - Globals.player.global_position).normalized() * 100

func _on_body_entered(body: Node2D) -> void:
	if not body == Globals.player:
		return
	if change_level_timer.is_stopped():
		change_level_timer.start(1.5)

func _on_change_level_timer_timeout() -> void:
	SceneManager.change_level()
	queue_free()