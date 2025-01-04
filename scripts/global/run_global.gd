extends Node


var current_weapon_index: int = 0
var PLAYER: CharacterBody2D
var WEAPON_PLAYER: CharacterBody2D

var SPEED_MULTIPLIER: float = 1
var INVULNERABILITY_TIME_MULTIPLIER: float = 1

var weapons: Array[PackedScene] = [
	preload("res://scenes/weapons/boomerang.tscn"),
	preload("res://scenes/weapons/boomerang.tscn"),
	preload("res://scenes/weapons/boomerang.tscn"),
]

var rng = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()


func swith_weapon(delta_index: int) -> void:
	current_weapon_index = get_negative_index(
		weapons,
		current_weapon_index + delta_index
	)

func get_negative_index(arr: Array, idx: int) -> int:
	var real_idx = idx % arr.size() if idx >= 0 else arr.size() + idx
	return real_idx


func get_closest_player(glob_pos: Vector2) -> CharacterBody2D:
	if WEAPON_PLAYER != null:
		return WEAPON_PLAYER
	return PLAYER
