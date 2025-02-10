class_name Level
extends Node2D

@export var grid_size: int = 200
@export var drunkward_iterations: int = 1000

@onready var tm_layer = $TileMapLayer
@onready var portal_spawn_timer = $PortalSpawnTimer

var weapon_chest_scene: PackedScene = preload("res://Scenes/gun_chest.tscn")
var ammo_chest_scene: PackedScene = preload("res://Scenes/ammo_chest.tscn")
var camera_scene: PackedScene = preload("res://Scenes/camera_controller.tscn")

const WALL := Globals.MapTile.WALL
const FLOOR := Globals.MapTile.FLOOR
const WEAPON_CHEST := Globals.MapTile.WEAPON_CHEST
const AMMO_CHEST := Globals.MapTile.AMMO_CHEST
const ATLAS_WIDTH = 12
const DESERT_TILESET_ID = 0


static var enemy_spawn_chance: float = 0.000
static var minimal_enemy_per_level: int = 5
static var iterations: int = 1
static var minimal_boss_per_level: int = 0

var boss_per_level: int = 0
var grid: Array = []
var portal_position = Vector2.ZERO
var level_enemy_count = 0 :
	set(value):
		print("enemy_count mudou para: ", value)
		level_enemy_count = value
		if level_enemy_count <= 0:
			portal_spawn_timer.start(randf_range(1.5, 2))
			portal_position = Globals.player.global_position

func on_game_started() -> void:
	iterations = 1
	enemy_spawn_chance = 0.0002
	minimal_enemy_per_level = 5
	minimal_boss_per_level = 0

func _ready() -> void:
	SignalBus.game_started.connect(on_game_started)
	SignalBus.level_changed.emit(iterations)

	enemy_spawn_chance += 0.0002

	if iterations % 2 == 0:
		minimal_enemy_per_level += 1

	if iterations % 5 == 0:
		minimal_boss_per_level += 1

	iterations += 1

	portal_spawn_timer.connect("timeout", _on_portal_spawn_timer_timeout)
	generate_level()
	Globals.level = self

func _on_portal_spawn_timer_timeout() -> void:
	spawn_portal_around_player()

func _on_enemy_death(points: int):
	level_enemy_count -= 1
	SignalBus.points_changed.emit(points)

func generate_level() -> void:
	# Initialize grid
	for x in range(grid_size):
		grid.append([])
		for y in range(grid_size):
			grid[x].append(WALL)

	# Drunkard walk
	var drunkman: DrunkardWalk = DrunkardWalk.new(Vector2i(grid_size / 2, grid_size / 2))
	for i in range(drunkward_iterations):

		if randf() < 0.02:
			# Make a 3x3 floor area around the drunkman
			for x in range(-1, 2):
				for y in range(-1, 2):
					var pos: Vector2i = drunkman.get_pos() + Vector2i(x, y)
					if pos.x < 0 or pos.x >= grid_size or pos.y < 0 or pos.y >= grid_size:
						continue
					grid[pos.x][pos.y] = FLOOR
		else:
			var _position: Vector2i = drunkman.move(grid_size)
			grid[_position.x][_position.y] = FLOOR

			if randf() < 0.10:
				grid[_position.x][_position.y] = WEAPON_CHEST
			if randf() < 0.05:
				grid[_position.x][_position.y] = AMMO_CHEST

	# Add player
	add_child(Globals.player)

	# Set player position and adjust to the center of the tile
	Globals.player.position = Vector2(drunkman.pos.x * Globals.tile_size, drunkman.pos.y * Globals.tile_size)
	Globals.player.position += Vector2(Globals.half_tile, Globals.half_tile) # Adjust player position to the center of the tile
	SignalBus.player_entered_level.emit()

	# Set tilemap and instantiate chests
	for x in range(grid_size):
		for y in range(grid_size):
			if grid[x][y] == WALL:
				var bitmask := get_bitmask(x, y)
				var atlas_coord := get_atlas_coord_from_bitmask(bitmask)
				tm_layer.set_cell(Vector2i(x, y), DESERT_TILESET_ID, atlas_coord)
			elif grid[x][y] == FLOOR:
				tm_layer.set_cell(Vector2i(x, y), DESERT_TILESET_ID, Vector2i(2, 3))
				call_deferred("spawn_enemy_chance", x, y)
			elif grid[x][y] == WEAPON_CHEST:
				tm_layer.set_cell(Vector2i(x, y), DESERT_TILESET_ID, Vector2i(2, 3))
				spawn_entity(weapon_chest_scene, Vector2(x * Globals.tile_size, y * Globals.tile_size))
			elif grid[x][y] == AMMO_CHEST:
				tm_layer.set_cell(Vector2i(x, y), DESERT_TILESET_ID, Vector2i(2, 3))
				spawn_entity(ammo_chest_scene, Vector2(x * Globals.tile_size, y * Globals.tile_size))

	if level_enemy_count < minimal_enemy_per_level:
		spawn_enemy_random_position()

	if boss_per_level < minimal_boss_per_level:
		spawn_boss_random_position()

	# Leave only one chest
	var gun_chests = Utils.get_all_nodes(self, GunChest)
	var ammo_chests = Utils.get_all_nodes(self, AmmoChest)

	remove_chests(ammo_chests)
	remove_chests(gun_chests)

	# Spawn camera
	var camera: Camera2D = camera_scene.instantiate()
	Globals.camera = camera
	camera.set_target(Globals.player)
	add_child(camera)

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
		0: return Vector2i(2, 3)  # Sem vizinhos
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

func spawn_portal_around_player() -> void:
	var portal_scene: PackedScene = preload("res://Scenes/portal.tscn")
	var portal: Portal = portal_scene.instantiate()
	portal.global_position = portal_position
	add_sibling(portal)

func destroy_tile(_position: Vector2i) -> void:
	# check out of bounds
	if _position.x < 0 or _position.x >= grid_size or _position.y < 0 or _position.y >= grid_size:
		return
	grid[_position.x][_position.y] = FLOOR
	tm_layer.set_cell(_position, DESERT_TILESET_ID, Vector2i(2, 3))

func spawn_entity(scene: PackedScene, _global_position: Vector2) -> Object:
	var entity = scene.instantiate()
	entity.global_position = _global_position
	add_child(entity)
	return entity

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		# Spawn big bandit
		if event.keycode == KEY_P and event.pressed:
			spawn_entity(Globals.big_bandit_scene, get_global_mouse_position())
		# Spawn ammo
		if event.keycode == KEY_F5 and event.pressed:
			spawn_entity(AmmoManager.ammo_drop_scene, get_global_mouse_position())
		# Spawn gun chest
		if event.keycode == KEY_F6 and event.pressed:
			spawn_entity(weapon_chest_scene, get_global_mouse_position())
		# Spawn Scorption
		if event.keycode == KEY_F7 and event.pressed:
			spawn_entity(Globals.scorpion_scene, get_global_mouse_position())


func get_random_enemy() -> PackedScene:
	# Bandit 60% chance and Scorpion 40% chance
	var enemy_scenes: Array = [Globals.bandit_scene, Globals.scorpion_scene]
	var chance = randf()
	if chance < 0.6:
		return Globals.bandit_scene
	else:
		return Globals.scorpion_scene

func spawn_enemy_chance(x, y) -> void:
	if randf() < enemy_spawn_chance:
		spawn_enemy(x, y)

func spawn_enemy(x, y) -> void:
	var scene = get_random_enemy()
	var enemy = spawn_entity(scene, Vector2(x * Globals.tile_size, y * Globals.tile_size))
	enemy.connect("died", _on_enemy_death)
	level_enemy_count += 1

func spawn_boss(x, y) -> void:
	var boss = spawn_entity(Globals.big_bandit_scene, Vector2(x * Globals.tile_size, y * Globals.tile_size))
	boss.connect("died", _on_enemy_death)
	level_enemy_count += 1
	boss_per_level += 1

func spawn_enemy_random_position() -> void:
	var avaialble_positions = tm_layer.get_used_cells()
	var lambd = func(x: Vector2i) -> bool:
		return grid[x.x][x.y] == FLOOR
	var floor_positions = avaialble_positions.filter(lambd)
	if floor_positions.size() == 0:
		return

	while level_enemy_count < minimal_enemy_per_level:
		var random_position = floor_positions[randi() % floor_positions.size()]
		spawn_enemy(random_position.x, random_position.y)

func spawn_boss_random_position() -> void:
	var avaialble_positions = tm_layer.get_used_cells()
	var lambd = func(x: Vector2i) -> bool:
		return grid[x.x][x.y] == FLOOR
	var floor_positions = avaialble_positions.filter(lambd)
	if floor_positions.size() == 0:
		return

	while boss_per_level < minimal_boss_per_level:
		var random_position = floor_positions[randi() % floor_positions.size()]
		spawn_boss(random_position.x, random_position.y)
