extends CanvasLayer


@onready var bullet_count: Label = $AmmoContainer/BulletCount
@onready var bullet_bar: TextureProgressBar = $AmmoContainer/BulletProgressBar

@onready var shell_count: Label = $AmmoContainer/ShellCount
@onready var shell_bar: TextureProgressBar = $AmmoContainer/ShellProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.game_started.connect(_on_game_start)
	SignalBus.ammo_changed.connect(_on_ammo_changed)
	hide()

func _on_game_start() -> void:
	show()

func _on_ammo_changed(type: int, value: int) -> void:
	match type:
		AmmoTypes.BULLET_TYPE:
			bullet_count.text = str(value)
			bullet_bar.value = value
		AmmoTypes.SHELL_TYPE:
			shell_count.text = str(value)
			shell_bar.value = value
