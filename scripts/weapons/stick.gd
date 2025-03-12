extends DefaultWeapon

@export var ROTATION_SPEED: float = 900
@export var MAX_BOUNCES_AMOUNT: int = 10
var bounces_amount: int = 0
@onready var live_timer: Timer = $Timers/LiveTimer
@export var live_time: float = 4


func _ready() -> void:
	super._ready()
	direction = direction.normalized()
	velocity = SPEED * direction
	live_timer.start(live_time)

func calc_animations(delta) -> void:
	var horiz_direction: int = sign(velocity.x)
	if horiz_direction == 0:
		horiz_direction = 1
	rotational_part.rotation_degrees += horiz_direction * delta * ROTATION_SPEED


func _physics_process(delta: float) -> void:
	if bounces_amount >= MAX_BOUNCES_AMOUNT:
		destroy()
	calc_animations(delta)
	move_with_bounce(delta)


func move_with_bounce(delta) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision and have_to_response_on_collision:
		var reflect = collision.get_remainder().bounce(collision.get_normal())
		velocity = velocity.bounce(collision.get_normal())
		move_and_collide(reflect)
		bounces_amount += 1

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.has_method("get_hit"):
		body.get_hit(DAMAGE)


func _on_live_timer_timeout() -> void:
	bounces_amount = MAX_BOUNCES_AMOUNT - 1
