extends Area2D

func _ready() -> void:
	call_deferred("explode")
	
func explode() -> void:
	var level = Globals.level
	var tiles_to_destroy = []
	var global = global_position


	var start_pos = floor(global_position / Globals.tile_size)

	for x in range(-1, 2):
		for y in range(-1, 2):
			var tile_pos = start_pos + Vector2(x, y)
			tiles_to_destroy.append(tile_pos)

	for tile_pos in tiles_to_destroy:
		level.destroy_tile(tile_pos)