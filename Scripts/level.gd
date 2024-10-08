extends Node

# Pseudo codigo para gerar um level

# Criar uma grid de N x N inicializada em 1
# Aplicar Drunkard Walk no centro da grid setando para 0 por onde passa
# Player é iniciado onde o Drunkard termina.
# itera sob a grid final criando os tiles

# chão = 0
# parede = 1

@export var grid_size: int = 20
@export var drunkward_iterations: int = 100

@onready var wall_scene: PackedScene = preload("res://Scenes/wall.tscn")

var grid: PackedInt32Array = PackedInt32Array()

func _ready() -> void:
    create_grid()

func create_grid() -> void:
    grid.resize(grid_size * grid_size)
    grid.fill(1)

    var drunkman: DrunkardWalk = DrunkardWalk.new(Vector2i(grid_size / 2, grid_size / 2))

    for i in range(drunkward_iterations):
        var position: Vector2i = drunkman.move(grid_size)
        grid[matrix_index(position.x, position.y)] = 0

    # TODO: Player.instantiate() in drunkman.position

    for x in range(grid_size):
        for y in range(grid_size):
            if grid[matrix_index(x, y)] == 1:
                var wall: Node2D = wall_scene.instantiate()
                wall.position = Vector2(x * 16, y * 16)
                add_child(wall)

func matrix_index(x: int, y: int) -> int:
    return x * grid_size + y