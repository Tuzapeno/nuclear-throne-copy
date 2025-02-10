class_name DrunkardWalk

enum Direction { UP, DOWN, LEFT, RIGHT }

var pos: Vector2i

func _init(start_position) -> void:
    self.pos = start_position

func move(grid_size: int) -> Vector2:

    var direction: int = randi() % 4
    match direction:
        Direction.UP:
            pos.y -= 1
        Direction.DOWN:
            pos.y += 1
        Direction.LEFT:
            pos.x -= 1
        Direction.RIGHT:
            pos.x += 1

    # Prevent out of bounds and keep the map without open walls in the edges
    if pos.x < 1 or pos.x > grid_size-2 or pos.y < 1 or pos.y > grid_size-2:
        pos = Vector2i(grid_size / 2, grid_size / 2)

    pos.x = clamp(pos.x, 0, grid_size - 1)
    pos.y = clamp(pos.y, 0, grid_size - 1)

    return pos

func get_pos() -> Vector2i:
    return pos
