extends Node

enum MapTile { WALL, FLOOR, WEAPON_CHEST, AMMO_CHEST }

const weapon_drop_scene_path: String = "res://Scenes/Weapons/Drops/"

var starting_weapon_scene := preload("res://Scenes/Weapons/shotgun.tscn")

var player: CharacterBody2D = null
var tile_size: int = 32
var half_tile: int = tile_size / 2




