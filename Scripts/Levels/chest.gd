class_name Chest
extends Area2D

@export var open_sprite: Texture2D
@export var closed_sprite: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

var is_open: bool = false

func _ready() -> void:
	sprite.texture = closed_sprite

func _on_body_entered(_body:Node2D) -> void:
	if is_open:
		return

	sprite.texture = open_sprite
	action()
	is_open = true

func action() -> void:
	pass
