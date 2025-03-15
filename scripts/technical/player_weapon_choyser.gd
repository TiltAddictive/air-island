extends Node
class_name WeaponPathUtil

@export var WEAPON_PREFIX_PATH: String = "res://scenes/weapons/"
@export var BAN_WEAPON_PATHES: Array[String] = ["res://scenes/weapons/default_weapon.tscn"]

func get_player_weapons() -> Array[String]:
	var weapons = RunGlobal.weapons
	var result: Array[String] = []
	for weapon in weapons:
		result.append(weapon.resource_path)
	return result


func update_current_player_weapons() -> void:
	var player_weapons_amount: int = RunGlobal.weapons.size()
	RunGlobal.weapons = []
	for i in range(player_weapons_amount):
		RunGlobal.weapons.append(load(get_new_weapon_path()))


func get_new_weapons_pathes() -> Array[String]:
	var all_weapons: Array[String] = PathUtils.get_scenes_from_path(WEAPON_PREFIX_PATH)
	var current_weapons = get_player_weapons()
	return all_weapons.filter(func(w): return not current_weapons.has(w) and not BAN_WEAPON_PATHES.has(w))


func get_new_weapon_path() -> String:
	var val = get_new_weapons_pathes().pick_random()
	if val == null:
		return ""
	return val
