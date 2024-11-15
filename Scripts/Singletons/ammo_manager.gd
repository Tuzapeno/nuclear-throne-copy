extends Node

const MAX_AMMO = {
    AmmoTypes.BULLET_TYPE: 255,
    AmmoTypes.ENERGY_TYPE: 55,
    AmmoTypes.SHELL_TYPE: 55,
    AmmoTypes.EXPLOSIVE_TYPE: 55,
    AmmoTypes.BOLT_TYPE: 55
}

var ammo: Dictionary = {}

func _ready() -> void:
    init_ammo()

func has_ammo(type: int, fire_cost: int) -> bool:
    return ammo[type] >= fire_cost

func add_ammo(type: int, amount: int) -> void:
    ammo[type] = int(clamp(ammo[type] + amount, 0, MAX_AMMO[type]))
    SignalBus.ammo_changed.emit(type, ammo[type])

func spend_ammo(type: int, amount: int) -> void:
    add_ammo(type, -amount)

func add_ammo_all(amount: int) -> void:
    for type in MAX_AMMO.keys():
        add_ammo(type, amount)

func init_ammo() -> void:
    for type in MAX_AMMO.keys():
        ammo[type] = MAX_AMMO[type] / 2
        SignalBus.ammo_changed.emit(type, ammo[type])