extends DefaultEnemy

func _ready() -> void:
	super._ready()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	move_and_slide()


func calc_move(_delta: float) -> void:
	if not calc_velocity:
		return
	var player_position: Vector2 = get_player_position()
	if player_position == null:
		player_position = prev_player_position
	else:
		prev_player_position = player_position
	velocity = ((player_position - global_position).normalized()) * SPEED
