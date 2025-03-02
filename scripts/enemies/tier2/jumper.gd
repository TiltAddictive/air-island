extends DefaultEnemy


@export var SPEED_REDUCTION_MULTIPLIER: float = 0.95

# Timer
@onready var jump_reload_timer: Timer = $Timers/JumpReloadTimer
@export var jump_reload_time: float = 3
@export var jump_reload_time_error_rate: float = 0.5
@onready var friction_timer: Timer = $Timers/FrictionTimer
var friction_time: float = 0.01

func _ready() -> void:
	super._ready()
	friction_timer.wait_time = friction_time
	jump_reload_timer.start(calc_jump_reload_time())


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	move_and_slide()


func jump_to_player():
	var player_position: Vector2 = get_player_position()
	set_jump_velocity(player_position)


func set_jump_velocity(player_position: Vector2) -> void:
	direction = (player_position - global_position).normalized()
	velocity = direction * SPEED


func make_it_slower() -> void:
	if abs(velocity.x) <= ConstantsGlobal.VELOCITY_EPS:
		velocity.x = 0
	if abs(velocity.y) <= ConstantsGlobal.VELOCITY_EPS:
		velocity.y = 0
	if velocity != Vector2.ZERO:
		velocity *= SPEED_REDUCTION_MULTIPLIER


func calc_jump_reload_time() -> float:
	return randf_range(
		jump_reload_time - jump_reload_time_error_rate,
		jump_reload_time + jump_reload_time_error_rate,
	)


func calc_animation():
	return


func _on_jump_reload_timer_timeout() -> void:
	jump_reload_timer.start(calc_jump_reload_time())
	friction_timer.start()
	animation_player.play("jump_preparation")


func _on_friction_timer_timeout() -> void:
	make_it_slower()
	friction_timer.start(friction_time)
