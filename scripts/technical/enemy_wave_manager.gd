extends Node2D
class_name EnemyWaveManager

signal wave_ends
signal stage_ends
signal wave_starts
signal all_waves_ends

@export var ENEMY_PREFIX_PATH: String = "res://scenes/enemies/"
@export var BOSSES_PREFIX_PATH: String = "res://scenes/enemies/bosses/"
var WAVES: Dictionary = {}
@export var ENEMY_NODE: Node2D
@export var ENEMY_BULLETS_NODE: Node2D
@export var waves_amount: int = 1
@export var current_wave: int = 1
@export var stages_amount: int = 2
@export var current_stage: int = 1
@onready var enemies_scenes_pathes: Array[PackedScene] = []
@export var ZONE_SPAWNER: ZoneSpawner
var waiting: bool = false

@export var MIN_VAWES_AMOUNT: int = 9
@export var MAX_VAWES_AMOUNT: int = 12

var enemy_spawned: bool = false
var prev_wave_was_bossfight: bool = true

var AVAILABLE_TIERES = ["tier1", "tier2"]
@export var TIER_ENEMIES: Dictionary = {
	"tier1": [
		preload("res://scenes/enemies/tier1/navigation_enemy.tscn"),
		preload("res://scenes/enemies/tier1/walker.tscn"),
		preload("res://scenes/enemies/tier1/the_eye_of_cthulhu.tscn"),
		#preload("res://scenes/enemies/tier2/lazer_wizard.tscn"),
	],
	"tier2": [
		preload("res://scenes/enemies/tier2/explosive_wizard.tscn"),
		preload("res://scenes/enemies/tier2/jumper.tscn"),
		preload("res://scenes/enemies/tier2/walker_shooter.tscn"),
	]
}

@export var BOSSES: Array[PackedScene] = [
	preload("res://scenes/enemies/bosses/summoner.tscn"),
	preload("res://scenes/enemies/bosses/fly_boss.tscn"),
]


# Player
@export var MIN_AVAILABLE_DISTANCE_TO_PLAYER: float = 60

@onready var generating_opponents_delay_timer: Timer = $GeneratingOpponentsDelayTimer
var generating_opponents_delay_time: float = 4

@onready var average_wave_audio_stream_player_2d: CustomAudioStreamPlayer2D = $Sounds/AverageWaveAudioStreamPlayer2D
@onready var boss_battle_audio_stream_player_2d: CustomAudioStreamPlayer2D = $Sounds/BossBattleAudioStreamPlayer2D


func _ready() -> void:
	pass


func start() -> void:
	generate_waves()
	generating_opponents_delay_timer.start(generating_opponents_delay_time)


func _physics_process(_delta: float) -> void:
	if waiting:
		return
	var enemies_amount = ENEMY_NODE.get_child_count()
	if (enemies_amount > 0 and enemy_spawned) or (not enemy_spawned):
		return
	if not generating_opponents_delay_timer.is_stopped():
		return
	wave_ends.emit(current_wave, waves_amount, current_stage, stages_amount)
	if current_wave == waves_amount:
		stage_ends.emit(current_stage, stages_amount)
		current_stage += 1
		return
	current_wave += 1
	if current_stage == stages_amount and current_wave == 1:
		wave_starts.emit(current_wave)
		generating_opponents_delay_timer.start(generating_opponents_delay_time)
		enemy_spawned = false
		return
	wave_starts.emit(current_wave)
	generating_opponents_delay_timer.start(generating_opponents_delay_time)
	enemy_spawned = false


func is_position_valid(candidate_position: Vector2) -> bool:
	if (candidate_position - RunGlobal.get_closest_player(candidate_position).global_position).length() > MIN_AVAILABLE_DISTANCE_TO_PLAYER:
		return true
	return false


func generate_waves() -> void:
	WAVES = {}
	current_wave = 1
	waves_amount = randi_range(MIN_VAWES_AMOUNT, MAX_VAWES_AMOUNT)
	for i in range(1, waves_amount + 1):
		WAVES[i] = {
			"tieres": get_available_tieres_in_wave(i),
			"amount": get_amount_of_enemies_in_wave(i)
		}
	waves_amount += 1


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
	return 10 + int(current_wave * 1.7)

func _on_generating_opponents_delay_timer_timeout() -> void:
	if ENEMY_NODE.get_child_count() > 0:
		generating_opponents_delay_timer.start(generating_opponents_delay_time)
		return
	ConstantsGlobal.clear_node(ENEMY_BULLETS_NODE)

	if current_wave != waves_amount:
		generate_wave()
		boss_battle_audio_stream_player_2d.stop()
		if not average_wave_audio_stream_player_2d.playing:
			average_wave_audio_stream_player_2d.custom_play()
	else:
		average_wave_audio_stream_player_2d.stop()
		if not boss_battle_audio_stream_player_2d.playing:
			boss_battle_audio_stream_player_2d.custom_play()
		generate_boss()


func generate_wave():
	if current_wave not in WAVES:
		return
	enemies_scenes_pathes = []
	for tier in WAVES[current_wave]["tieres"]:
		enemies_scenes_pathes.append_array(TIER_ENEMIES[tier])
	var enemies_amount: int = WAVES[current_wave]["amount"]
	for enemy_number in range(enemies_amount):
		var candidate_position: Vector2 = ZONE_SPAWNER.choose_item_position(self)
		if candidate_position == Vector2.INF:
			continue
		var enemy_scene: PackedScene = enemies_scenes_pathes.pick_random()
		var enemy_node = enemy_scene.instantiate()
		enemy_node.global_position = candidate_position
		enemy_node.ENEMY_ATACK_NODE = ENEMY_BULLETS_NODE
		enemy_node.ZONE_SPAWNER = ZONE_SPAWNER
		ENEMY_NODE.add_child(enemy_node)
	enemy_spawned = true


func generate_boss() -> void:
	var candidate_position: Vector2 = Vector2.INF
	while candidate_position == Vector2.INF:
		candidate_position = ZONE_SPAWNER.choose_item_position(self)
	var boss_node = BOSSES.pick_random().instantiate()
	boss_node.global_position = candidate_position
	boss_node.ENEMY_ATACK_NODE = ENEMY_BULLETS_NODE
	boss_node.ZONE_SPAWNER = ZONE_SPAWNER
	ENEMY_NODE.add_child(boss_node)
	enemy_spawned = true
