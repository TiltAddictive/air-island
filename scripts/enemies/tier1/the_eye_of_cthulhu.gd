extends DefaultEnemy

@export var COLLISION_POWER = 0.9
@export var IMPULSE_WAIT_TIME_SEC: float = 3
@onready var slide_wait_timer: Timer = $Timers/SlideWaitTimer
@export var SPEED_FOR_IDLE_ANIMATION: float = 20

func _ready() -> void:
	super._ready()
	slide_wait_timer.wait_time = IMPULSE_WAIT_TIME_SEC
	slide_wait_timer.start()
	$ShadowPoint/Shadow.set_shadow_size(0)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	move_and_slide()


func calc_animation():
	if velocity == Vector2.ZERO and animation_player.current_animation != "start_impuilse":
		animation_player.play("idle")


func calc_move(delta: float) -> void:
	velocity *= (1.0 - COLLISION_POWER) ** delta
	if velocity.length() >= SPEED_FOR_IDLE_ANIMATION:
		slide_wait_timer.start()
		return
	velocity = Vector2.ZERO


func set_impulse_to_player():
	player_position = get_player_position()
	direction = (player_position - global_position).normalized()
	velocity = direction * SPEED


func _on_slide_wait_timer_timeout() -> void:
	animation_player.play("start_impuilse")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "idle" and slide_wait_timer.time_left != 0:
		animation_player.play("idle")
