extends Node2D
class_name Bomb


@export var DAMAGE: float = 1
@export var can_attack: bool = false


func _ready() -> void:
	$Sprite2D/AnimationPlayer.play("spawn")


func death():
	queue_free()


func _physics_process(delta: float) -> void:
	if not can_attack:
		return
	for body in $Area2D.get_overlapping_bodies():
		if not body.has_method("get_hit"):
			return
		body.get_hit(DAMAGE)
		can_attack = false
