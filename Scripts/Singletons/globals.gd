extends Node

var weapon_drop_scene_path: String = "res://Scenes/Weapons/Drops/"

var starting_weapon_scene = preload("res://Scenes/Weapons/pistol.tscn")

var starting_weapon: Weapon = starting_weapon_scene.instantiate()

var player: CharacterBody2D = null
var tile_size: int = 32
var half_tile: int = tile_size / 2


