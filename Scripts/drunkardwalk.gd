class_name DrunkardWalk

enum Direction { UP, DOWN, LEFT, RIGHT }

var position: Vector2i

func _init(start_position) -> void:
    self.position = start_position

func move(grid_size: int) -> Vector2:
    var direction: int = randi() % 4
    match direction:
        Direction.UP:
            position.y -= 1
        Direction.DOWN:
            position.y += 1
        Direction.LEFT:
            position.x -= 1
        Direction.RIGHT:
            position.x += 1

    # Prevent out of bounds and keep the map without open walls in the edges
    if position.x < 1 or position.x > grid_size-2 or position.y < 1 or position.y > grid_size-2:
        position = Vector2i(grid_size / 2, grid_size / 2)

    position.x = clamp(position.x, 0, grid_size - 1)
    position.y = clamp(position.y, 0, grid_size - 1)

    return position
