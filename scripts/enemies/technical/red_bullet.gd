extends CharacterBody2D


var direction: Vector2
@export var live_time: float = 20
@export var SPEED: float = 200
@export var DAMAGE: float = 200
@export var ROTATION_SPEED: float = 30
@onready var rotational_part: Node2D = $RotationalPart
@export var REJECTION_FORCE_VALUE = 50

func _ready() -> void:
	velocity = direction.normalized() * SPEED
	$LiveTimer.start(live_time)


func _physics_process(delta: float) -> void:
	calc_animations(delta)
	calc_attack()
	move_and_slide()


func calc_animations(delta) -> void:
	var horiz_direction: int = sign(velocity.x)
	if horiz_direction == 0:
		horiz_direction = 1
	rotational_part.rotation_degrees += horiz_direction * delta * ROTATION_SPEED


func calc_attack():
	for body in $RotationalPart/AttackArea.get_overlapping_bodies():
		if not body.has_method("get_hit"):
			return
		var impulse_vector_direction: Vector2 = (body.global_position - self.global_position).normalized() * REJECTION_FORCE_VALUE
		body.get_hit(DAMAGE, impulse_vector_direction)
		queue_free()


func _on_live_timer_timeout() -> void:
	queue_free()
