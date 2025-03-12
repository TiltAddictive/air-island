extends DefaultWeapon

@export var ROTATION_SPEED: float = 900

@export var MAX_DISTANCE_REACH_TIME_SEC: float = 1
@export var MAX_DISTANCE: float = 150
@export var BACKWARDS_MAX_DISTANCE: float = 300
var start_position: Vector2 = Vector2.ZERO
var TARGET_DISTATION: float = 250
var covered_distance: float = 0

enum STATES {MOVE_FORWARD, MOVE_BACKWARDS}
var curent_state: STATES = STATES.MOVE_FORWARD
func set_weapon_behaviour_states():
	BEHAVIOUR = {
		STATES.MOVE_FORWARD: calc_move_forward_state,
		STATES.MOVE_BACKWARDS: calc_move_backwards_state,
	}

func _ready() -> void:
	super._ready()
	direction = direction.normalized()
	start_position = global_position
	velocity = SPEED * direction

func _physics_process(delta: float) -> void:
	BEHAVIOUR[curent_state].call(delta)
	var is_collided: bool = move_and_slide()
	if is_collided:
		weapon_collided_with_wall.emit()

func _process(delta: float) -> void:
	calc_animations(delta)

func calc_speed(_delta: float):
	var velocity_sign: int = 1
	if curent_state == STATES.MOVE_BACKWARDS:
		velocity_sign = -1
	
	velocity = velocity_sign * direction * SPEED

func calc_move_forward_state(delta):
	covered_distance = (global_position - start_position).length()
	calc_speed(delta)
	if covered_distance >= MAX_DISTANCE:
		start_position = global_position
		curent_state = STATES.MOVE_BACKWARDS

func calc_move_backwards_state(delta):
	covered_distance = (global_position - start_position).length()
	calc_speed(delta)
	if covered_distance >= BACKWARDS_MAX_DISTANCE:
		destroy()

func calc_animations(delta) -> void:
	var horiz_direction: int = sign(velocity.x)
	if horiz_direction == 0:
		horiz_direction = 1
	rotational_part.rotation_degrees += horiz_direction * delta * ROTATION_SPEED

func _on_weapon_collided_with_wall() -> void:
	if not have_to_response_on_collision:
		return
	
	if curent_state == STATES.MOVE_BACKWARDS:
		weapon_have_to_destroy.emit()
		return

	curent_state = STATES.MOVE_BACKWARDS
	restart_collision_response_waiting()

func _on_collision_response_timer_timeout() -> void:
	have_to_response_on_collision = true

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.has_method("get_hit"):
		body.get_hit(DAMAGE)
