extends Node2D

@export var MARGIN_RADIUS: float = 75
@export var ENVIRONMENT_ITEM_NODE: Node2D
@export var environmental_items: Array[PackedScene] = []
@export var ZONE_SPAWNER: ZoneSpawner
@onready var spawn_gap_timer: Timer = $SpawnGapTimer
var _items_amount: int

func _ready() -> void:
	pass


func generate_level(items_amount: int = 7) -> void:
	_items_amount = items_amount
	spawn_gap_timer.start()


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


func _on_spawn_gap_timer_timeout() -> void:
	if _items_amount <= 0:
		return
	var chosen_item: PackedScene = choose_item()
	if chosen_item == null:
		return
	_items_amount -= 1
	var item_position: Vector2 = ZONE_SPAWNER.choose_item_position(self)
	if item_position == Vector2.INF:
		return
	spawn_item(chosen_item, item_position)
	spawn_gap_timer.start()
