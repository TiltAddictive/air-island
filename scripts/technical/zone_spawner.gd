extends Node2D
class_name ZoneSpawner

@export var MAXIMUM_ATTEMPTS: int = 100

@export var TOPLEFT_ZONE_POINT: Node2D
@export var TOPRIGHT_ZONE_POINT: Node2D
@export var DOWNLEFT_ZONE_POINT: Node2D
@export var DOWNRIGHT_ZONE_POINT: Node2D

var LEFT_X: float
var RIGHT_X: float
var TOP_Y: float
var BOTTOM_Y: float


func _ready() -> void:
	var top_left = TOPLEFT_ZONE_POINT.global_position
	var top_right = TOPRIGHT_ZONE_POINT.global_position
	var down_left = DOWNLEFT_ZONE_POINT.global_position
	var down_right = DOWNRIGHT_ZONE_POINT.global_position

	LEFT_X = min(top_left.x, down_left.x)
	RIGHT_X = max(top_right.x, down_right.x)
	TOP_Y = min(top_left.y, top_right.y)
	BOTTOM_Y = max(down_left.y, down_right.y)


func choose_item_position(position_validate_checker: Node2D) -> Vector2:
	for attempt in range(MAXIMUM_ATTEMPTS):
		var random_x = RunGlobal.rng.randf_range(LEFT_X, RIGHT_X)
		var random_y = RunGlobal.rng.randf_range(TOP_Y, BOTTOM_Y)
		var candidate_position = Vector2(random_x, random_y)
		
		if position_validate_checker.is_position_valid(candidate_position):
			return candidate_position

	return Vector2.INF
