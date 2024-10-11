extends Control

@onready var worldScene: PackedScene = preload("res://Scenes/world.tscn")
@onready var level: PackedScene = preload("res://Scenes/level.tscn")
@onready var player_scene: PackedScene = preload("res://Scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_fish_button_pressed() -> void:
	print("Fish was selected!!")
	Globals.player = player_scene.instantiate() # Fish Parameters
	SceneManager.change_scene(level, "Level Scene")
