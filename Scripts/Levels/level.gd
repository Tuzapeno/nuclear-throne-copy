extends Node2D

@export var grid_size: int = 200
@export var drunkward_iterations: int = 1000

@onready var tm_layer = $TileMapLayer

var weapon_chest_scene: PackedScene = preload("res://Scenes/gun_chest.tscn")
var ammo_chest_scene: PackedScene = preload("res://Scenes/ammo_chest.tscn")

const WALL := Globals.MapTile.WALL
const FLOOR := Globals.MapTile.FLOOR
const WEAPON_CHEST := Globals.MapTile.WEAPON_CHEST
const AMMO_CHEST := Globals.MapTile.AMMO_CHEST
const ATLAS_WIDTH = 12
const DESERT_TILESET_ID = 0

# TODO: Otimizar para que as paredes que estão encobertas por outras não chequem por colisões.
# TODO: Paralelismo para não demorar na geração do mapa
# TODO: Criar uma classe para cada drunkard walk diferente: deserto, junkyward etc.

var grid: Array = []

func _ready() -> void:
	generate_level()

func generate_level() -> void:
	# Initialize grid
	for x in range(grid_size):
		grid.append([])
		for y in range(grid_size):
			grid[x].append(WALL)

	# Drunkard walk
	var drunkman: DrunkardWalk = DrunkardWalk.new(Vector2i(grid_size / 2, grid_size / 2))
	for i in range(drunkward_iterations):
		var _position: Vector2i = drunkman.move(grid_size)
		grid[_position.x][_position.y] = FLOOR
		if randf() < 0.10:
			grid[_position.x][_position.y] = WEAPON_CHEST
		if randf() < 0.05:
			grid[_position.x][_position.y] = AMMO_CHEST

	# Add player
	add_child(Globals.player)

	# Set player position and adjust to the center of the tile
	Globals.player.position = Vector2(drunkman.position.x * Globals.tile_size, drunkman.position.y * Globals.tile_size)
	Globals.player.position += Vector2(Globals.half_tile, Globals.half_tile) # Adjust player position to the center of the tile

	print("WALL: ", WALL)
	print("FLOOR: ", FLOOR)

	# Set tilemap and instantiate chests
	for x in range(grid_size):
		for y in range(grid_size):

			if grid[x][y] == WALL:
				var bitmask := get_bitmask(x, y)
				var atlas_coord := get_atlas_coord_from_bitmask(bitmask)
				tm_layer.set_cell(Vector2i(x, y), DESERT_TILESET_ID, atlas_coord)

			elif grid[x][y] == FLOOR:
				tm_layer.set_cell(Vector2i(x, y), DESERT_TILESET_ID, Vector2i(2, 3))
			
			elif grid[x][y] == WEAPON_CHEST:
				tm_layer.set_cell(Vector2i(x, y), DESERT_TILESET_ID, Vector2i(2, 3))
				var weapon_chest = weapon_chest_scene.instantiate()
				weapon_chest.global_position = Vector2(x * Globals.tile_size, y * Globals.tile_size)
				add_child(weapon_chest)

			elif grid[x][y] == AMMO_CHEST:
				tm_layer.set_cell(Vector2i(x, y), DESERT_TILESET_ID, Vector2i(2, 3))
				var ammo_chest = ammo_chest_scene.instantiate()
				ammo_chest.global_position = Vector2(x * Globals.tile_size, y * Globals.tile_size)
				add_child(ammo_chest)

			else:
				print("TYPE OF TILE NOT RECOGNIZED: ", grid[x][y])

	# Leave only one chest
	var gun_chests = Utils.get_all_nodes(self, GunChest)
	var ammo_chests = Utils.get_all_nodes(self, AmmoChest)
	
	remove_chests(ammo_chests)
	remove_chests(gun_chests)
	

				

func get_bitmask(x: int, y: int) -> int:
	var bitmask := 0
	# Only check cardinal directions
	if is_wall(x, y - 1): bitmask |= 1  # North
	if is_wall(x + 1, y): bitmask |= 2  # East
	if is_wall(x, y + 1): bitmask |= 4  # South
	if is_wall(x - 1, y): bitmask |= 8  # West
	return bitmask

func get_atlas_coord_from_bitmask(bitmask: int) -> Vector2i:
	# Convert 4-bit bitmask to tileset coordinates
	# This mapping assumes a 47-tile autotile layout
	match bitmask:
		
		0: return Vector2i(0, 0)  # Sem vizinhos
		1: return Vector2i(2, 0)  # North
		2: return Vector2i(0, 1)  # East
		3: return Vector2i(1, 1)  # Northeast
		4: return Vector2i(4, 1)  # South
		5: return Vector2i(0, 2)  # North and South
		6: return Vector2i(3, 2)  # East and South
		7: return Vector2i(4, 2)  # North and East and South
		8: return Vector2i(3, 0)  # West
		9: return Vector2i(4, 0)  # Northwest
		10: return Vector2i(2, 1)  # East and West
		11: return Vector2i(3, 1)  # North and East and West
		12: return Vector2i(1, 2)  # South and West
		13: return Vector2i(2, 2)  # North and South and West
		14: return Vector2i(0, 3)  # East and South and West
		15: return Vector2i(1, 3)  # All
		
		# Default (shouldn't happen)
		_: return Vector2i(1, 1)

func is_wall(x: int, y: int) -> bool:
	if x < 0 or x >= grid_size or y < 0 or y >= grid_size:
		return true  # Treat out of bounds as walls
	return grid[x][y] == WALL

func remove_chests(chest_array: Array) -> void:
	chest_array.pop_back()
	for gun in chest_array:
		gun.queue_free()