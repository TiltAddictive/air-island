extends DefaultWeapon

@export var ROTATION_SPEED: float = 300
@onready var damage_area: Area2D = $RotationalPart/DamageArea

@onready var live_timer: Timer = $Timers/LiveTimer
@export var live_time: float = 0.3


func _ready() -> void:
	super._ready()
	velocity = direction * SPEED
	live_timer.start(live_time)
	disabled_collision()


func _physics_process(delta: float) -> void:
	calc_animations(delta)
	move_and_slide()


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
	rotational_part.rotation_degrees += horiz_direction * delta * ROTATION_SPEED



func _on_live_timer_timeout() -> void:
	damage_everybody_in_damage_area()
	destroy()
