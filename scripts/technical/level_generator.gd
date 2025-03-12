extends Node2D

signal level_is_cleared

@export var MIN_AVAILABLE_MARGIN_DISTANCE: float = 100
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
	if not is_sufficient_distance(RunGlobal.get_closest_player(candidate_position).global_position, candidate_position, true):
		return false
	for child in ENVIRONMENT_ITEM_NODE.get_children():
		if child is Node2D:
			if not is_sufficient_distance(child.global_position, candidate_position):
				return false
	return true

func is_sufficient_distance(
		occupied_position: Vector2,
		candidate_position: Vector2,
		is_occupied_by_player: bool = false
) -> bool:
	var min_available_margin_distance = MIN_AVAILABLE_MARGIN_DISTANCE
	if is_occupied_by_player:
		min_available_margin_distance /= 3
	if occupied_position.distance_to(candidate_position) < min_available_margin_distance:
		return false
	return true


func spawn_item(item: PackedScene, item_position: Vector2) -> void:
	var item_node = item.instantiate()
	item_node.global_position = item_position
	ENVIRONMENT_ITEM_NODE.add_child(item_node)


func clear_level():
	for item in ENVIRONMENT_ITEM_NODE.get_children():
		if item.has_method("disappear"):
			item.disappear()
		else:
			item.queue_free()
	$LevelClearanceCheckerTimer.start(1)


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


func _on_level_clearance_checker_timer_timeout() -> void:
	if ENVIRONMENT_ITEM_NODE.get_child_count() > 0:
		$LevelClearanceCheckerTimer.start(1)
	level_is_cleared.emit()
