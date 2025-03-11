extends Node2D
class_name EnemyWaveManager

signal wave_ends
signal wave_starts
signal all_waves_ends

@export var ENEMY_PREFIX_PATH: String = "res://scenes/enemies/"
var WAVES: Dictionary = {}
@export var ENEMY_NODE: Node2D
@export var ENEMY_BULLETS_NODE: Node2D
@export var waves_amount: int = 1
@export var current_wave: int = 0
@onready var enemies_scenes_pathes: Array[String] = []
@export var ZONE_SPAWNER: ZoneSpawner

@export var MIN_VAWES_AMOUNT: int = 7
@export var MAX_VAWES_AMOUNT: int = 12

var AVAILABLE_TIERES = ["tier1", "tier2"]


# Player
@export var MIN_AVAILABLE_DISTANCE_TO_PLAYER: float = 60

@onready var generating_opponents_delay_timer: Timer = $GeneratingOpponentsDelayTimer
var generating_opponents_delay_time: float = 2

func _ready() -> void:
	generate_waves()

func _physics_process(delta: float) -> void:
	if check_enemies_amount() > 0:
		return
	wave_ends.emit(current_wave)
	if not generating_opponents_delay_timer.is_stopped():
		return
	current_wave += 1
	wave_starts.emit()
	generating_opponents_delay_timer.start(generating_opponents_delay_time)


func check_enemies_amount() -> int:
	return ENEMY_NODE.get_child_count()


func start_new_wave_stream():
	current_wave = 1


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
	if (candidate_position - RunGlobal.get_closest_player(global_position).global_position).length() > MIN_AVAILABLE_DISTANCE_TO_PLAYER:
		return true
	return false


func generate_waves() -> void:
	WAVES = {}
	waves_amount = randi_range(MIN_VAWES_AMOUNT, MAX_VAWES_AMOUNT)
	for i in range(1, waves_amount + 1):
		WAVES[i] = {
			"tieres": get_available_tieres_in_wave(i),
			"amount": get_amount_of_enemies_in_wave(i)
		}


func get_available_tieres_in_wave(curent_wave: int) -> Array[String]:
	if curent_wave < 2:
		return [AVAILABLE_TIERES[0]]
	if current_wave < 4:
		return [AVAILABLE_TIERES[0], AVAILABLE_TIERES[1]]
	var availailable_tier_list: Array[String] = [AVAILABLE_TIERES[1]]
	if randf() < 0.3:
		availailable_tier_list.append(AVAILABLE_TIERES[0])
	return availailable_tier_list


func get_amount_of_enemies_in_wave(curent_wave: int) -> int:
	return 6 + int(current_wave * 1.7)

func _on_generating_opponents_delay_timer_timeout() -> void:
	if current_wave not in WAVES:
		return
	var tier_pathes: Array[String] = get_tier_pathes_for_wave(current_wave)
	enemies_scenes_pathes = []
	for path in tier_pathes:
		enemies_scenes_pathes.append_array(PathUtils.get_scenes_from_path(path))
	var enemies_amount: int = WAVES[current_wave]["amount"]
	
	for enemy in range(enemies_amount):
		var enemy_scene: PackedScene = choose_random_scene_from_list(enemies_scenes_pathes)
		var enemy_node = enemy_scene.instantiate()
		enemy_node.global_position = ZONE_SPAWNER.choose_item_position(self)
		enemy_node.ENEMY_ATACK_NODE = ENEMY_BULLETS_NODE
		ENEMY_NODE.add_child(enemy_node)
