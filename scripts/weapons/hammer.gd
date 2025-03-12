extends DefaultWeapon

@export var ROTATION_SPEED: float = 300
@onready var damage_area: Area2D = $RotationalPart/DamageArea

@onready var live_timer: Timer = $Timers/LiveTimer
@export var live_time: float = 0.3

# Air Flows
@onready var air_flows: Node2D = $RotationalPart/AirFlows


func _ready() -> void:
	super._ready()
	velocity = direction * SPEED
	live_timer.start(live_time)


func _physics_process(delta: float) -> void:
	calc_animations(delta)
	var collided: bool = move_and_slide()
	if collided and have_to_response_on_collision:
		weapon_collided_with_wall.emit()


func damage_body(body: Node2D) -> void:
	if body.has_method("get_hit"):
		var impulse_vector_direction: Vector2 = (body.global_position - self.global_position).normalized() * REJECTION_FORCE_VALUE
		body.get_hit(DAMAGE, impulse_vector_direction, IMPULSE_IMPACT_TIME)


func damage_everybody_in_damage_area():
	var bodies_list: Array[Node2D] = damage_area.get_overlapping_bodies()
	for body in bodies_list:
		damage_body(body)


func calc_animations(delta) -> void:
	var horiz_direction: int = sign(velocity.x)
	if horiz_direction == 0:
		horiz_direction = 1
	var rotation_degrees_delta: float = horiz_direction * delta * ROTATION_SPEED
	rotational_part.rotation_degrees += rotation_degrees_delta
	air_flows.scale.x = -horiz_direction
	$RotationalPart/AirFlows.rotation_degrees += 0.3 * rotation_degrees_delta


func _on_live_timer_timeout() -> void:
	damage_everybody_in_damage_area()
	destroy()


func _on_weapon_collided_with_wall() -> void:
	_on_live_timer_timeout()
