extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Globals.game_started.connect(_on_game_start)


func _on_game_start() -> void:
	print("Signal reached")
	show()
