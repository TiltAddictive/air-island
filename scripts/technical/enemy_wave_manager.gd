extends Node2D
class_name EnemyWaveManager

@export var ENEMY_PREFIX_PATH: String = "res://scenes/enemies/"
var WAVES: Dictionary = {
	1: {"tieres": ["tier1"], "amount": 6},
	2: {"tieres": ["tier1", "tier2"], "amount": 6},
	3: {"tieres": ["tier1", "tier2"], "amount": 8},
	4: {"tieres": ["tier2"], "amount": 8},
	5: {"tieres": ["tier2"], "amount": 10},
}
@export var ENEMY_NODE: Node2D
@export var ENEMY_BULLETS_NODE: Node2D
@export var current_wave: int = 1
@onready var enemies_scenes_pathes: Array[String] = []
@export var ZONE_SPAWNER: ZoneSpawner

@onready var generating_opponents_delay_timer: Timer = $GeneratingOpponentsDelayTimer
var generating_opponents_delay_time: float = 2


func _physics_process(delta: float) -> void:
	if check_enemies_amount() > 0:
		return
	if not generating_opponents_delay_timer.is_stopped():
		return
	generating_opponents_delay_timer.start(generating_opponents_delay_time)


func check_enemies_amount() -> int:
	return ENEMY_NODE.get_child_count()


func get_scenes_from_path(path: String) -> Array:
	if not DirAccess.dir_exists_absolute(path):
		return []
	var dir = DirAccess.open(path)

	if dir == null:
		print("Не удалось открыть папку:", path)
		return []

	var scenes: Array = []

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tscn"):
			scenes.append(path + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	return scenes


func choose_random_scene_from_list(scenes: Array[String]) -> PackedScene:
	var random_scene_path = scenes.pick_random()
	return load(random_scene_path) as PackedScene


func get_tier_pathes_for_wave(current_wave: int) -> Array[String]:
	var result: Array[String] = []
	var wave_tieres: Array = WAVES[current_wave]["tieres"]

	for el in wave_tieres:
		result.append("%s%s/" % [ENEMY_PREFIX_PATH, el])
	return result


func is_position_valid(candidate_position: Vector2) -> bool:
	return true


func _on_generating_opponents_delay_timer_timeout() -> void:
	if current_wave not in WAVES:
		return
	var tier_pathes: Array[String] = get_tier_pathes_for_wave(current_wave)
	enemies_scenes_pathes = []
	for path in tier_pathes:
		enemies_scenes_pathes.append_array(get_scenes_from_path(path))
	var enemies_amount: int = WAVES[current_wave]["amount"]
	
	for enemy in range(enemies_amount):
		var enemy_scene: PackedScene = choose_random_scene_from_list(enemies_scenes_pathes)
		var enemy_node = enemy_scene.instantiate()
		enemy_node.global_position = ZONE_SPAWNER.choose_item_position(self)
		enemy_node.ENEMY_ATACK_NODE = ENEMY_BULLETS_NODE
		ENEMY_NODE.add_child(enemy_node)
	current_wave += 1
