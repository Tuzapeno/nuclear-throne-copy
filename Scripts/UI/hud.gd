extends CanvasLayer

@export var hud: Control

# Health Exports

@export var health_bar: TextureProgressBar
@export var health_label: Label

# Ammo exports

@export var bullet_count: Label
@export var bullet_bar: TextureProgressBar

@export var shell_count: Label
@export var shell_bar: TextureProgressBar

@export var level_count: Label

func _on_ammo_changed(type: int, value: int) -> void:
	update_ammo(type, value)

func _on_health_changed(value: int, max_value: int) -> void:
	update_health(value, max_value)

func _on_level_changed(level: int) -> void:
	level_count.text = "LEVEL: " + str(level)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.ammo_changed.connect(_on_ammo_changed)
	SignalBus.health_changed.connect(_on_health_changed)
	SignalBus.level_changed.connect(_on_level_changed)

func update_health(value: int, max_value: int) -> void:
	health_label.text = str(value) + "/" + str(max_value)
	health_bar.max_value = max_value
	health_bar.value = value

func update_ammo(type: int, value: int) -> void:
	match type:
		AmmoTypes.BULLET_TYPE:
			bullet_count.text = str(value)
			bullet_bar.value = value
		AmmoTypes.SHELL_TYPE:
			shell_count.text = str(value)
			shell_bar.value = value

func hide_hud() -> void:
	hud.hide()

func show_hud() -> void:
	hud.show()
