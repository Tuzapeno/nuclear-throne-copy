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

    position.x = clamp(position.x, 0, grid_size - 1)
    position.y = clamp(position.y, 0, grid_size - 1)

    return position
