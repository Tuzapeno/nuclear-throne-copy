extends Node

var death_screen_scene: PackedScene = preload("res://Scenes/death_screen.tscn")

@export var canvas_layer: CanvasLayer

func _ready() -> void:
	SignalBus.player_died.connect(_on_player_died)
	SignalBus.player_created.connect(_on_player_created)

func _on_player_created() -> void:
	AmmoManager.init_ammo()
	canvas_layer.show_hud()

func _on_player_died(killed_by: Node2D):
	Globals.camera.set_target(killed_by) # Show what enemy killed the player
	canvas_layer.add_child(death_screen_scene.instantiate()) # Add the death screen scene
	print("Player killed by: ", killed_by) # log
	canvas_layer.hide_hud()
