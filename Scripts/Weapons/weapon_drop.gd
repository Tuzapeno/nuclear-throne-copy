class_name WeaponDrop
extends Node2D

@export var weapon_scene: PackedScene

@onready var label: Label = $Label

var weapon: Weapon = null

func _ready() -> void:
	weapon = weapon_scene.instantiate()
	print("Weapon created at ready: ", weapon)
	label.text = "Pick up (E)"
	label.hide()

var can_pickup: bool = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("use") and can_pickup:
		pick_up()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		can_pickup = true
		label.show()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		can_pickup = false
		label.hide()

func pick_up() -> void:
	assert(Globals.player != null, "Attempting to pick up weapon but player is null with weapon: " + weapon.name)
	print("Picking up weapon ", weapon.name)
	Globals.player.pickup_weapon(weapon)
	queue_free()
