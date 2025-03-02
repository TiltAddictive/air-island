extends Node


func get_random_area(center: Vector2, range: float) -> Vector2:
	var random_x = center.x + randf_range(-range, range)
	var random_y = center.y + randf_range(-range, range)
	return Vector2(random_x, random_y)
