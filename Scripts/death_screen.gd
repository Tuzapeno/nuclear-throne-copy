extends Control

var scn: PackedScene = preload("res://Scenes/character_selection.tscn")

func _on_button_pressed() -> void:
	SceneManager.change_scene(scn, "Character Selection")
	SignalBus.game_started.emit()
	queue_free()
