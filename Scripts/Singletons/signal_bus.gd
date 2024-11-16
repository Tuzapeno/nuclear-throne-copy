extends Node

signal game_started
signal ammo_changed(type: int, amount: int)
signal health_changed(value: int, max_value: int)
signal player_killed_by(killed_by: Node2D)
signal player_created(health, max_health)
signal player_died
signal player_entered_level()