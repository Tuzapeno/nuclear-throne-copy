class_name WeaponResource
extends Resource

enum AmmoType { 
    BULLET_TYPE, 
    ENERGY_TYPE,
    SHELL_TYPE,
    EXPLOSIVE_TYPE,
    BOLT_TYPE
}

enum FireType {
    SINGLE,
    AUTO,
    BURST
}


@export var my_name: String = ""
@export var type: FireType = FireType.SINGLE
@export var ammo_type: AmmoType = AmmoType.BULLET_TYPE
@export var fire_rate: float = 0.0
@export var fire_cost: int = 0
@export var kickback: int = 0
