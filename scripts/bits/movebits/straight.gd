class_name StraightMoveBit2D extends MoveBit2D
## Moves in a straight, preset direction. Good for things like bullets, for example.

## The speeds to move towards for the x and y value.
@export var max_speeds:Vector2 = Vector2(30.0, 30.0)
## How much to move towards the max speeds, per second.
@export var acceleration:float = 30.0

func on_active() -> void:
	if master != null:
		master.set_direction(max_speeds)

func phys_active(delta:float) -> void:
	if master != null:
		master.mover.velocity = vec2_move_towards(master.mover.velocity, max_speeds, acceleration * delta * 60)
