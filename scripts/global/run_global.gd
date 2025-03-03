extends Node

signal weapon_switched

var current_weapon_index: int = 1
var PLAYER: CharacterBody2D
var WEAPON_PLAYER: CharacterBody2D

var SPEED_MULTIPLIER: float = 1
var INVULNERABILITY_TIME_MULTIPLIER: float = 1

var weapons: Array[PackedScene] = [
	preload("res://scenes/weapons/boomerang.tscn"),
	preload("res://scenes/weapons/hammer.tscn"),
]
var weapon_timers: Array[Timer] = []

var rng = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	initialize_weapon_timers()



func initialize_weapon_timers():
	for timer in weapon_timers:
		timer.queue_free()
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

func get_changed_index(arr: Array, idx: int) -> int:
	var real_idx = idx % arr.size() if idx >= 0 else arr.size() + idx
	return real_idx


func get_closest_player(_glob_pos: Vector2) -> CharacterBody2D:
	if WEAPON_PLAYER != null:
		return WEAPON_PLAYER
	return PLAYER

func launch_current_weapon() -> Node2D:
	print(weapon_timers[current_weapon_index].time_left)
	if weapon_timers[current_weapon_index].time_left != 0:
		return null
	weapon_timers[current_weapon_index].start()
	print(weapon_timers[current_weapon_index].time_left)
	print(weapon_timers[current_weapon_index].time_left)
	return weapons[current_weapon_index].instantiate()
	
