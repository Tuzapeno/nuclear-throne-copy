class_name WeaponDrop
extends Node2D

@export var weapon_scene: PackedScene

var weapon: Weapon = null

func _ready() -> void:
	weapon = weapon_scene.instantiate()
	print("Weapon created at ready: ", weapon)

var can_pickup: bool = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("use") and can_pickup:
		pick_up()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		can_pickup = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		can_pickup = false

func pick_up() -> void:
	assert(Globals.player != null, "Attempting to pick up weapon but player is null with weapon: " + weapon.name)
	print("Picking up weapon ", weapon.name)
	Globals.player.inventory.pickup_weapon(weapon)
	queue_free()
