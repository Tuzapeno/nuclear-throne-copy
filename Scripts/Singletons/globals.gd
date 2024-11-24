extends Node

enum MapTile { WALL, FLOOR, WEAPON_CHEST, AMMO_CHEST }

const weapon_drop_scene_path: String = "res://Scenes/Weapons/Drops/"

var starting_weapon_scene := preload("res://Scenes/Weapons/shotgun.tscn")

var bandit_scene = preload("res://Scenes/bandit.tscn")
var big_bandit_scene = preload("res://Scenes/big_bandit.tscn")
var floating_text_scene = preload("res://Scenes/floating_text.tscn")
var health_drop_scene = preload("res://Scenes/health_drop.tscn")


var player: CharacterBody2D = null
var camera: Camera2D = null

var tile_size: int = 16
var half_tile: int = tile_size / 2

var level: Level = null

func create_floating_text(text: String, _global_position: Vector2) -> void:
        var floating_text = floating_text_scene.instantiate()
        var animation = floating_text.anim_player.get_animation("flow_up")
        var track_id = animation.find_track(".:position", 0)

        animation.track_set_key_value(track_id, 0, _global_position + Vector2(0, -20))
        animation.track_set_key_value(track_id, 1, _global_position + Vector2(0, -40))
        floating_text.label.text = text
        floating_text.z_index = 100
        Globals.player.add_sibling(floating_text)
        

