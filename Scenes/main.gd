extends Node

var death_screen_scene: PackedScene = preload("res://Scenes/death_screen.tscn")

@export var hud_node: CanvasLayer

func _ready() -> void:
	SignalBus.player_died.connect(_on_player_died)

func _on_player_died(killed_by: Node2D):
	print("Player killed by: ", killed_by)
	Globals.camera.set_target(killed_by)
	hud_node.add_child(death_screen_scene.instantiate())
