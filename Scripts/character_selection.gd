extends Control

@onready var worldScene: PackedScene = preload("res://Scenes/world.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_fish_button_pressed() -> void:
	print("Fish was selected!!")
	SceneManager.change_scene(worldScene, "World Scene")