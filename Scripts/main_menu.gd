extends Control

@onready var character_selection_scene: PackedScene = preload("res://Scenes/character_selection.tscn")

# Signal for when the exit button is pressed
func _on_exit_button_pressed() -> void:
	get_tree().quit()

# Signal for when the play button is pressed
func _on_play_button_pressed() -> void:
	SceneManager.change_scene(character_selection_scene, "Character Selection")

	