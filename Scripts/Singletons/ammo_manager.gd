extends Node

signal ammo_changed(type: int, amount: int)

enum { BULLET, ENERGY, SHELL, EXPLOSIVE, BOLT }

enum { MAX_BULLET = 255,
	MAX_ENERGY = 55,
	MAX_SHELL = 55,
	MAX_EXPLOSIVE = 55,
	MAX_BOLT = 55 }

var cebola = 999

var ammo = {
	BULLET: cebola,
	ENERGY: cebola,
	SHELL: cebola,
	EXPLOSIVE: cebola,
	BOLT: cebola
}

var max_ammo = {
	BULLET: MAX_BULLET,
	ENERGY: MAX_ENERGY,
	SHELL: MAX_SHELL,
	EXPLOSIVE: MAX_EXPLOSIVE,
	BOLT: MAX_BOLT
}

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_O and event.pressed:
			add_ammo(BULLET, 10)
			add_ammo(ENERGY, 10)
			add_ammo(SHELL, 10)
			add_ammo(EXPLOSIVE, 10)
			add_ammo(BOLT, 10)

func has_ammo(key: int, fire_cost: int) -> bool:
	return ammo[key] >= fire_cost

func add_ammo(key: int, amount: int) -> void:
	ammo[key] += amount
	ammo[key] = clamp(ammo[key], 0, max_ammo[key])
	emit_signal("ammo_changed", key, ammo[key])

func spend_ammo(key: int, amount: int) -> void:
	ammo[key] -= amount
	ammo[key] = clamp(ammo[key], 0, max_ammo[key])
	emit_signal("ammo_changed", key, ammo[key])