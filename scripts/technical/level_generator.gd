extends Node2D

@export var MARGIN_RADIUS: float = 75
@export var ENVIRONMENT_ITEM_NODE: Node2D
@export var environmental_items: Array[PackedScene] = []
@export var ZONE_SPAWNER: ZoneSpawner

func _ready() -> void:
	pass


func generate_level(items_amount: int = 7) -> void:
	while items_amount > 0:
		var chosen_item: PackedScene = choose_item()
		if chosen_item == null:
			return
		items_amount -= 1
		var item_position: Vector2 = ZONE_SPAWNER.choose_item_position(self)
		if item_position == Vector2.INF:
			continue
		spawn_item(chosen_item, item_position)


func choose_item() -> PackedScene:
	return environmental_items.pick_random()


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
