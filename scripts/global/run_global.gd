extends Node

signal weapon_switched
signal player_run_out_of_hp

var current_weapon_index: int = 1
var PLAYER: CharacterBody2D
var WEAPON_NODE: Node2D
var WEAPON_PLAYER: CharacterBody2D
var ENEMY_WAVE_MANAGER_NODE: Node2D

var player_max_hp: int = 3
var _player_hp: int

var player_hp: int:
	get:
		return _player_hp
	set (value):
		_player_hp = min(max(0, value), player_max_hp)
		if _player_hp <= 0:
			player_run_out_of_hp.emit()

var SPEED_MULTIPLIER: float = 1
var INVULNERABILITY_TIME_MULTIPLIER: float = 1

var weapons: Array[PackedScene] = [
	preload("res://scenes/weapons/boomerang.tscn"),
	preload("res://scenes/weapons/hammer.tscn"),
	preload("res://scenes/weapons/stick.tscn"),
]
var weapon_timers: Array[Timer] = []

var rng = RandomNumberGenerator.new()


func _ready() -> void:
	new_run()


func new_run() -> void:
	player_hp = player_max_hp
	rng.randomize()
	initialize_weapon_timers()

func initialize_run() -> void:
	player_hp = player_max_hp


func initialize_weapon_timers():
	for timer in weapon_timers:
		timer.queue_free()
	weapon_timers = []
	for weapon_scene in weapons:
		var weapon_node = weapon_scene.instantiate()
		var timer = Timer.new()
		timer.autostart = false
		timer.wait_time = weapon_node.RELOAD_TIME
		timer.one_shot = true
		weapon_node.queue_free()
		weapon_timers.append(timer)
		add_child(timer)


func swith_weapon(delta_index: int) -> void:
	current_weapon_index = get_changed_index(
		weapons,
		current_weapon_index + delta_index
	)
	weapon_switched.emit()


func replace_by_new_weapon(weapon_index: int, new_weapon_path: String):
	weapons[weapon_index] = load(new_weapon_path)
	initialize_weapon_timers()
	swith_weapon(0)
	weapon_switched.emit()


func get_changed_index(arr: Array, idx: int) -> int:
	var real_idx = idx % arr.size() if idx >= 0 else arr.size() + idx
	return real_idx


func get_closest_player(_glob_pos: Vector2) -> CharacterBody2D:
	var weapon_children: Array = WEAPON_NODE.get_children()
	if weapon_children.size() > 0:
		return weapon_children.pick_random()
	return PLAYER

func launch_current_weapon() -> Node2D:
	if weapon_timers[current_weapon_index].time_left != 0:
		return null
	weapon_timers[current_weapon_index].start()
	return weapons[current_weapon_index].instantiate()


func get_weapon_indexes() -> Array[int]:
	var center_index: int = RunGlobal.current_weapon_index
	var left_index: int = RunGlobal.get_changed_index(
		RunGlobal.weapons,
		center_index - 1
	)
	var right_index: int = RunGlobal.get_changed_index(
		RunGlobal.weapons,
		center_index + 1
	)
	return [left_index, center_index, right_index]
