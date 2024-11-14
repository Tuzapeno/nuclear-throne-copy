extends Node

signal game_started
signal ammo_changed(type: int, amount: int)
signal health_changed(value: int, max_value: int)
signal player_died(killed_by: Node2D)
signal player_creation(health, max_health)