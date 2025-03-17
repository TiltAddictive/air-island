extends Node

func _ready() -> void:
	print("RunAuxiliaryScript")

func get_random_area(center: Vector2, area_range: float) -> Vector2:
	var random_x = center.x + randf_range(-area_range, area_range)
	var random_y = center.y + randf_range(-area_range, area_range)
	return Vector2(random_x, random_y)
