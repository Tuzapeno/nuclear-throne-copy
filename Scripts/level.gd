extends Node

signal level_loaded

@export var grid_size: int = 30
@export var drunkward_iterations: int = 500

@onready var wall_scene: PackedScene = preload("res://Scenes/wall.tscn")
@onready var player_scene: PackedScene = preload("res://Scenes/player.tscn")

const WALL := Globals.MapTile.WALL
const FLOOR := Globals.MapTile.FLOOR
const WEAPON_CHEST := Globals.MapTile.WEAPON_CHEST
const AMMO_CHEST := Globals.MapTile.AMMO_CHEST



var grid: PackedInt32Array = PackedInt32Array()

func _ready() -> void:
	generate_level()
	level_loaded.emit()


func matrix_index(x: int, y: int) -> int:
	return x * grid_size + y

func generate_level() -> void:
	# Initialize grid
	grid.resize(grid_size * grid_size)
	grid.fill(WALL)

	# Drunkard walk
	var drunkman: DrunkardWalk = DrunkardWalk.new(Vector2i(grid_size / 2, grid_size / 2))
	for i in range(drunkward_iterations):
		var position: Vector2i = drunkman.move(grid_size)
		grid[matrix_index(position.x, position.y)] = FLOOR

	# Clear alone walls
	for x in range(grid_size):
		for y in range(grid_size):
			if check_solo_wall(x, y):
				grid[matrix_index(x, y)] = FLOOR



	# Instantiate player
	add_child(Globals.player)

	Globals.player.position = Vector2(drunkman.position.x * Globals.tile_size, drunkman.position.y * Globals.tile_size)
	Globals.player.position += Vector2(Globals.half_tile, Globals.half_tile) # Adjust player position to the center of the tile

	# Instantiate walls
	for x in range(grid_size):
		for y in range(grid_size):
			if grid[matrix_index(x, y)] == WALL:
				var wall: Node2D = wall_scene.instantiate()
				wall.position = Vector2(x * 32, y * 32)
				add_child(wall)

	# Instantiate and center camera
	var camera: Camera2D = Globals.player.camera

	# Set camera properties
	camera.zoom = Vector2(2, 2)
	camera.limit_bottom = grid_size * Globals.tile_size
	camera.limit_right = grid_size * Globals.tile_size
	camera.limit_left = 0
	camera.limit_top = 0


func check_solo_wall(_x, _y):
	var count = 0

	if _x == 0 or _x == grid_size - 1:
		return false

	if _y == 0 or _y == grid_size - 1:
		return false

	if grid[matrix_index(_x + 1, _y)] == WALL:
		return false

	if grid[matrix_index(_x - 1, _y)] == WALL:
		return false

	if grid[matrix_index(_x, _y + 1)] == WALL:
		return false

	if grid[matrix_index(_x, _y - 1)] == WALL:
		return false

	if grid[matrix_index(_x + 1, _y + 1)] == WALL:
		return false

	if grid[matrix_index(_x - 1, _y - 1)] == WALL:
		return false

	if grid[matrix_index(_x + 1, _y - 1)] == WALL:
		return false

	if grid[matrix_index(_x - 1, _y + 1)] == WALL:
		return false

	return true
