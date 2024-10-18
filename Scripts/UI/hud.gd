extends CanvasLayer


@onready var bullet_count: Label = $AmmoContainer/BulletCount
@onready var bullet_bar: TextureProgressBar = $AmmoContainer/BulletProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.game_started.connect(_on_game_start)
	AmmoManager.ammo_changed.connect(_on_ammo_changed)
	hide()

func _on_game_start() -> void:
	print("Signal reached")
	show()

func _on_ammo_changed(type: int, value: int) -> void:
	match type:
		AmmoTypes.BULLET_TYPE:
			bullet_count.text = str(value)
			bullet_bar.value = value
