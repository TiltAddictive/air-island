extends Node2D

@export var TOPLEFT_ZONE_POINT: Node2D
@export var TOPRIGHT_ZONE_POINT: Node2D
@export var DOWNLEFT_ZONE_POINT: Node2D
@export var DOWNRIGHT_ZONE_POINT: Node2D
@export var MARGIN_RADIUS: float = 75
@export var MAXIMUM_ATTEMPTS: int = 100
@export var ENVIRONMENT_ITEM_NODE: Node2D
@export var environmental_items: Array[PackedScene] = []

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


func generate_level(items_amount: int = 7) -> void:
	while items_amount > 0:
		var chosen_item: PackedScene = choose_item()
		if chosen_item == null:
			return
		items_amount -= 1
		var item_position: Vector2 = choose_item_position()
		if item_position == Vector2.INF:
			continue
		spawn_item(chosen_item, item_position)


func choose_item() -> PackedScene:
	return environmental_items.pick_random()

func choose_item_position() -> Vector2:
	var top_left = TOPLEFT_ZONE_POINT.global_position
	var top_right = TOPRIGHT_ZONE_POINT.global_position
	var down_left = DOWNLEFT_ZONE_POINT.global_position
	var down_right = DOWNRIGHT_ZONE_POINT.global_position
	
	for attempt in MAXIMUM_ATTEMPTS:
		var random_x = RunGlobal.rng.randf_range(LEFT_X, RIGHT_X)
		var random_y = RunGlobal.rng.randf_range(TOP_Y, BOTTOM_Y)
		var candidate_position = Vector2(random_x, random_y)
		
		if is_position_valid(candidate_position):
			return candidate_position

	return Vector2.INF


func is_position_valid(candidate_position: Vector2) -> bool:
	for child in ENVIRONMENT_ITEM_NODE.get_children():
		if child is Node2D:
			var dist = child.global_position.distance_to(candidate_position)
			if dist < MARGIN_RADIUS:
				return false
	return true


func spawn_item(item: PackedScene, item_position: Vector2) -> void:
	var item_node = item.instantiate()
	item_node.global_position = item_position
	ENVIRONMENT_ITEM_NODE.add_child(item_node)


func clear_level():
	for item in ENVIRONMENT_ITEM_NODE.get_children():
		item.queue_free()
