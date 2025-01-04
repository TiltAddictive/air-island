extends Node2D

@export var TOPLEFT_ZONE_POINT: Node2D
@export var TOPRIGHT_ZONE_POINT: Node2D
@export var DOWNLEFT_ZONE_POINT: Node2D
@export var DOWNRIGHT_ZONE_POINT: Node2D
@export var indent: float
@export var ENVIRONMENT_ITEM_NODE: Node2D

@export var environmental_items: Array[PackedScene] = []


func generate_level(items_amount: int = 7) -> void:
	while items_amount > 0:
		var chosen_item: PackedScene = choose_item()
		if chosen_item == null:
			return
		spawn_item(chosen_item, choose_item_position())
		items_amount -= 1


func choose_item() -> PackedScene:
	return environmental_items.pick_random()

func choose_item_position() -> Vector2:
	var top_left = TOPLEFT_ZONE_POINT.global_position
	var top_right = TOPRIGHT_ZONE_POINT.global_position
	var down_left = DOWNLEFT_ZONE_POINT.global_position
	var down_right = DOWNRIGHT_ZONE_POINT.global_position

	var left_x = min(top_left.x, down_left.x)
	var right_x = max(top_right.x, down_right.x)
	var top_y = min(top_left.y, top_right.y)
	var bottom_y = max(down_left.y, down_right.y)

	var random_x = RunGlobal.rng.randf_range(left_x, right_x)
	var random_y = RunGlobal.rng.randf_range(top_y, bottom_y)

	return Vector2(random_x, random_y)

func spawn_item(item: PackedScene, item_position: Vector2) -> void:
	var item_node = item.instantiate()
	item_node.global_position = item_position
	ENVIRONMENT_ITEM_NODE.add_child(item_node)
