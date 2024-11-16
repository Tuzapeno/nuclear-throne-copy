class_name Chest
extends Area2D

@export var open_sprite: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

var is_open: bool = false

func _on_body_entered(body:Node2D) -> void:
	if body != Globals.player:
		return
	if is_open:
		return
	sprite.texture = open_sprite
	action()
	is_open = true

func action() -> void:
	pass
