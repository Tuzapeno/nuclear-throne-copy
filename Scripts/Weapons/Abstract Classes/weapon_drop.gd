class_name WeaponDrop
extends Area2D

static var pick_up_lock: Node2D = null

@export var weapon_scene: PackedScene

@onready var label: Label = $Label

var weapon: Weapon = null
var can_pickup: bool = false

func _ready() -> void:
	weapon = weapon_scene.instantiate()
	label.text = weapon.weapon_resource.my_name + " (E)"
	label.hide()

func _process(_delta: float) -> void:
	var bodies = get_overlapping_bodies()
	
	if len(bodies) == 0:
		can_pickup = false
		label.hide()
	else:
		for body in bodies:
			if body.name == "Player":
				can_pickup = true
				label.show()
				break
			else:
				can_pickup = false
				label.hide()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("use") and can_pickup:
		pick_up()
		

func pick_up() -> void:
	assert(Globals.player != null, "Attempting to pick up weapon but player is null with weapon: " + weapon.name)
	can_pickup = false
	Globals.player.pickup_weapon(weapon)
	queue_free()
