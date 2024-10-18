extends Node

signal ammo_changed(type: int, amount: int)

const MAX_AMMO = {
    AmmoTypes.BULLET_TYPE: 255,
    AmmoTypes.ENERGY_TYPE: 55,
    AmmoTypes.SHELL_TYPE: 55,
    AmmoTypes.EXPLOSIVE_TYPE: 55,
    AmmoTypes.BOLT_TYPE: 55
}

var ammo: Dictionary = {}

func _ready() -> void:
    for type in MAX_AMMO.keys():
        ammo[type] = MAX_AMMO[type] / 2 

# TODO: Add a debug class to handle debug inputs

# func _input(event: InputEvent) -> void:
#     if event.is_action_pressed("debug_add_ammo"):
#         for type in MAX_AMMO.keys():
#             add_ammo(type, 10)

func has_ammo(type: int, fire_cost: int) -> bool:
    return ammo[type] >= fire_cost

func add_ammo(type: int, amount: int) -> void:
    ammo[type] = int(clamp(ammo[type] + amount, 0, MAX_AMMO[type]))
    emit_signal("ammo_changed", type, ammo[type])

func spend_ammo(type: int, amount: int) -> void:
    add_ammo(type, -amount)