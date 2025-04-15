extends Node
class_name WeaponPathUtil

const WEAPON_PREFIX_PATH: String = "res://scenes/weapons/"
var AVAILABLE_WEAPONS: Array[PackedScene] = [
	preload("res://scenes/weapons/boomerang.tscn"),
	preload("res://scenes/weapons/bubble.tscn"),
	preload("res://scenes/weapons/hammer.tscn"),
	preload("res://scenes/weapons/stick.tscn"),
]

func update_current_player_weapons() -> void:
	var player_weapons_amount: int = RunGlobal.weapons.size()
	RunGlobal.weapons = []
	for i in range(player_weapons_amount):
		RunGlobal.weapons.append(get_new_weapon())


func get_new_weapons() -> Array[PackedScene]:
	var all_weapons: Array[PackedScene] = AVAILABLE_WEAPONS.duplicate()
	var current_weapons = RunGlobal.weapons
	return all_weapons.filter(func(w): return not current_weapons.has(w))


func get_new_weapon() -> PackedScene:
	var val = get_new_weapons().pick_random()
	return val
