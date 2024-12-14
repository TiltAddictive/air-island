extends CharacterBody2D
class_name EnvironmentObject

@export var hp: int = -1
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var hit_animation: String = "shaking"

func get_hit(damage: float) -> void:
	animation_player.play(hit_animation)
