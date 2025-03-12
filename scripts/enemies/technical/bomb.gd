extends Node2D
class_name Bomb


@export var DAMAGE: float = 1
@export var can_attack: bool = false
@export var REJECTION_FORCE_VALUE: float = 200


func _ready() -> void:
	$Sprite2D/AnimationPlayer.play("spawn")


func death():
	queue_free()


func _physics_process(_delta: float) -> void:
	if not can_attack:
		return
	for body in $Area2D.get_overlapping_bodies():
		if not body.has_method("get_hit"):
			return
		var impulse_vector_direction: Vector2 = (body.global_position - self.global_position).normalized() * REJECTION_FORCE_VALUE
		body.get_hit(DAMAGE, impulse_vector_direction)
		can_attack = false
