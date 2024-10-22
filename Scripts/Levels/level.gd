extends Node

@export var grid_size: int = 200
@export var drunkward_iterations: int = 1000

@onready var wall_scene: PackedScene = preload("res://Scenes/wall.tscn")

const WALL := Globals.MapTile.WALL
const FLOOR := Globals.MapTile.FLOOR
const WEAPON_CHEST := Globals.MapTile.WEAPON_CHEST
const AMMO_CHEST := Globals.MapTile.AMMO_CHEST

# TODO: Otimizar para que as paredes que estão encobertas por outras não chequem por colisões.
# TODO: Paralelismo para não demorar na geração do mapa

var grid: PackedInt32Array = PackedInt32Array()

func _ready() -> void:
	generate_level()


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

	# Add player
	add_child(Globals.player)

	# Set player position and adjust to the center of the tile
	Globals.player.position = Vector2(drunkman.position.x * Globals.tile_size, drunkman.position.y * Globals.tile_size)
	Globals.player.position += Vector2(Globals.half_tile, Globals.half_tile) # Adjust player position to the center of the tile

	# Instantiate walls

	var bottom_wall_shape: RectangleShape2D = load("res://Resources/Walls/bottom_wall.tres")

	for x in range(grid_size):
		for y in range(grid_size):
			if grid[matrix_index(x, y)] == WALL:
				var wall: Node2D = wall_scene.instantiate()
				wall.position = Vector2(x * Globals.tile_size, y * Globals.tile_size)
				add_child(wall)
				if is_floor_on_top(x, y):
					wall.get_node("CollisionShape2D").shape = bottom_wall_shape


func is_floor_on_top(_x, _y) -> bool:
	if _y == 0:
		return false

	if grid[matrix_index(_x, _y - 1)] == FLOOR:
		return true

	return false


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
