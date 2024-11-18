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

func add_ammo_pickup(type: int) -> void:
    match type:
        AmmoTypes.BULLET_TYPE:
            add_ammo(type, 32)
        AmmoTypes.ENERGY_TYPE:
            add_ammo(type, 10)
        AmmoTypes.SHELL_TYPE:
            add_ammo(type, 10)
        AmmoTypes.EXPLOSIVE_TYPE:
            add_ammo(type, 10)
        AmmoTypes.BOLT_TYPE:
            add_ammo(type, 10)

func spend_ammo(type: int, amount: int) -> void:
    add_ammo(type, -amount)

func add_ammo_all(amount: int) -> void:
    for type in MAX_AMMO.keys():
        add_ammo(type, amount)

func init_ammo() -> void:
    for type in MAX_AMMO.keys():
        ammo[type] = MAX_AMMO[type] / 2
        SignalBus.ammo_changed.emit(type, ammo[type])

func ammo_full(type: int) -> bool:
    return ammo[type] == MAX_AMMO[type]

func get_max_ammo(type: int) -> int:
    return MAX_AMMO[type]

func get_ammo(type: int) -> int:
    return ammo[type]

## Returns a dynamic chance of dropping ammo.
## The lower the ammo the higher the chance.
func ammo_drop_chance() -> bool:
    if not Globals.player:
        return false

    var limit: float = 0.50
    var primary = Globals.player.get_primary_weapon()
    var extra = Globals.player.get_extra_weapon()
    var current_ammo: float = 0
    var max_ammo: float = 0

    if primary:
        current_ammo += get_ammo(primary.get_ammo_type())
        max_ammo += get_max_ammo(primary.get_ammo_type())

    if extra:
        current_ammo += get_ammo(extra.get_ammo_type())
        max_ammo += get_max_ammo(extra.get_ammo_type())

    var chance: float = limit * (1 - (current_ammo / max_ammo))

    #print("Chance: ", chance)

    return randf() < chance