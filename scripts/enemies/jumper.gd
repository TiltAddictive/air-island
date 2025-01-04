extends DefaultEnemy


@export var SLOWER_VELOCITY: float = 15

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	var player_position: Vector2 = get_player_position()


func make_it_slower(delta: float):
	velocity -= direction * SLOWER_VELOCITY * delta
