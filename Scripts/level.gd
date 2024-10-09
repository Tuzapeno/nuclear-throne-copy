extends Node

@export var grid_size: int = 30
@export var drunkward_iterations: int = 500

@onready var wall_scene: PackedScene = preload("res://Scenes/wall.tscn")
@onready var player_scene: PackedScene = preload("res://Scenes/player.tscn")

var grid: PackedInt32Array = PackedInt32Array()

func _ready() -> void:
	generate_level()

func matrix_index(x: int, y: int) -> int:
	return x * grid_size + y

func generate_level() -> void:
	# Initialize grid
	grid.resize(grid_size * grid_size)
	grid.fill(1)

	# Drunkard walk
	var drunkman: DrunkardWalk = DrunkardWalk.new(Vector2i(grid_size / 2, grid_size / 2))
	for i in range(drunkward_iterations):
		var position: Vector2i = drunkman.move(grid_size)
		grid[matrix_index(position.x, position.y)] = 0

	# Instantiate player if is the first time else move player to the new position
	if Globals.player == null:
		print("Player doesn't exist, creating a new one")
		Globals.player = player_scene.instantiate()
		
	add_child(Globals.player)
	Globals.player.position = Vector2(drunkman.position.x * Globals.tile_size, drunkman.position.y * Globals.tile_size)
	Globals.player.position += Vector2(Globals.half_tile, Globals.half_tile) # Adjust player position to the center of the tile

	# Instantiate walls
	for x in range(grid_size):
		for y in range(grid_size):
			if grid[matrix_index(x, y)] == 1:
				var wall: Node2D = wall_scene.instantiate()
				wall.position = Vector2(x * 32, y * 32)
				add_child(wall)

	# Instantiate and center camera
	var camera: Camera2D = Camera2D.new()
	Globals.player.add_child(camera)

	# Set camera properties
	camera.zoom = Vector2(2, 2)
	camera.limit_bottom = grid_size * Globals.tile_size
	camera.limit_right = grid_size * Globals.tile_size
	camera.limit_left = 0
	camera.limit_top = 0
