extends DefaultEnemy
class_name Walker

@onready var additional_animation_player: AnimationPlayer = $RotationalPart/Sprite/AdditionalAnimationPlayer


func _ready() -> void:
	super._ready()
	generate_random_velocity()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)


func generate_random_velocity():
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * SPEED


func calc_move(delta: float) -> void:
	move_with_bounce(delta)
	return


func move_with_bounce(delta) -> void:
	if not calc_velocity:
		move_and_slide()
		return
	velocity = velocity.normalized() * SPEED
	if velocity.x <= ConstantsGlobal.VELOCITY_EPS * 50 and velocity.y <= ConstantsGlobal.VELOCITY_EPS * 50:
		generate_random_velocity()
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if not collision:
		return
	var reflect = collision.get_remainder().bounce(collision.get_normal())
	velocity = velocity.bounce(collision.get_normal())
	move_and_collide(reflect)
