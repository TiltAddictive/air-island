extends EnvironmentObject

@export var initial_shadow_size: int = 0
@export var result_shadow_size: int = 1

func _ready() -> void:
	$AnimationPlayer.play("falling_down")


func disappear():
	$AnimationPlayer.play("disappearance")


func set_shadow_size(initial: bool = false):
	var shadow_size: int = result_shadow_size
	if initial:
		shadow_size = result_shadow_size
	$ShadowPoint/Shadow.set_shadow_size(result_shadow_size)
