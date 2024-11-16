extends Node

#TODO: this node will handle scene changes and not SceneManager, for the
# purpose of avoiding using change_scene()

var death_screen_scene: PackedScene = preload("res://Scenes/death_screen.tscn")

@export var canvas_layer: CanvasLayer

var killed_by: Node2D = null

func _ready() -> void:
	SignalBus.player_killed_by.connect(_on_player_killed_by)
	SignalBus.player_created.connect(_on_player_created)
	SignalBus.player_died.connect(_on_player_died)

func _on_player_created() -> void:
	AmmoManager.init_ammo()
	canvas_layer.show_hud()

func _on_player_died() -> void:
	await SignalBus.player_killed_by
	if killed_by != null:
		Globals.camera.set_target(killed_by) # Show what enemy killed the player
		print("Player killed by: ", killed_by.name) # log

	canvas_layer.add_child(death_screen_scene.instantiate()) # Add the death screen scene
	canvas_layer.hide_hud()

func _on_player_killed_by(entity: Node2D):
	killed_by = entity
