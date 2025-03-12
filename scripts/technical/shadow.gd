extends Node2D

func _make_all_unvisible():
	$RotationalPart/WhiteOvalBig.visible = false
	$RotationalPart/WhiteOvalMiddle.visible = false
	$RotationalPart/WhiteOvalSmall.visible = false


func set_shadow_size(size: int):
	_make_all_unvisible()
	if size <=  0:
		$RotationalPart/WhiteOvalSmall.visible = true
	elif size == 1:
		$RotationalPart/WhiteOvalMiddle.visible = true
	else:
		$RotationalPart/WhiteOvalBig.visible = true
