extends Control

signal new_weapon_chosen

@export var ENEMY_PREFIX_PATH: String = "res://scenes/weapons/"
@export var BAN_WEAPON_PATHES: Array[String] = ["res://scenes/weapons/default_weapon.tscn"]

@onready var new_weapon_icon: TextureRect = $VBoxContainer/NewWeaponContainer/NewWeaponCard/NewWeaponIcon
@onready var new_weapon_name_label: Label = $VBoxContainer/NewWeaponContainer/NewWeaponCard/NewWeaponNameLabel

var new_weapon_path: String
var weapon_indexes
var new_weapon_info

func _ready() -> void:
	update()

func update() -> void:
	update_current_weapons_images()
	update_new_weapon_image()
	localize_text()

func localize_text():
	$VBoxContainer/CurrentWeaponsHBoxContainer/LeftWeaponCard/SwitchLeftWeaponButton.text = tr("replaceWeapon")
	$VBoxContainer/CurrentWeaponsHBoxContainer/CenterWeaponCard/SwitchCenterWeaponButton.text = tr("replaceWeapon")
	$VBoxContainer/CurrentWeaponsHBoxContainer/RightWeaponCard/SwitchRightWeaponButton.text = tr("replaceWeapon")


func update_current_weapons_images():
	weapon_indexes = RunGlobal.get_weapon_indexes()
	var left_weapon_info = PathUtils.get_weapon_image_path_and_title(weapon_indexes[0])
	var center_weapon_info = PathUtils.get_weapon_image_path_and_title(weapon_indexes[1])
	var right_weapon_info = PathUtils.get_weapon_image_path_and_title(weapon_indexes[2])
	$VBoxContainer/CurrentWeaponsHBoxContainer/LeftWeaponCard/LeftWeaponIcon.texture = load(left_weapon_info[0])
	$VBoxContainer/CurrentWeaponsHBoxContainer/LeftWeaponCard/LeftWeaponTitle.text = tr(left_weapon_info[1])
	$VBoxContainer/CurrentWeaponsHBoxContainer/CenterWeaponCard/CenterWeaponIcon.texture = load(center_weapon_info[0])
	$VBoxContainer/CurrentWeaponsHBoxContainer/CenterWeaponCard/CenterWeaponTitle.text = tr(center_weapon_info[1])
	$VBoxContainer/CurrentWeaponsHBoxContainer/RightWeaponCard/RightWeaponIcon.texture = load(right_weapon_info[0])
	$VBoxContainer/CurrentWeaponsHBoxContainer/RightWeaponCard/RightWeaponTitle.text = tr(right_weapon_info[1])


func update_new_weapon_image():
	new_weapon_path = get_new_weapon_path()
	new_weapon_info = PathUtils.get_weapon_scene_image_path_and_title(load(new_weapon_path))
	new_weapon_icon.texture = load(
		new_weapon_info[0]
	)
	new_weapon_name_label.text = tr(new_weapon_info[1])


func get_new_weapons_pathes() -> Array[String]:
	var all_weapons: Array[String] = PathUtils.get_scenes_from_path(ENEMY_PREFIX_PATH)
	var current_weapons = get_player_weapons()
	return all_weapons.filter(func(w): return not current_weapons.has(w) and not BAN_WEAPON_PATHES.has(w))


func get_new_weapon_path() -> String:
	var val = get_new_weapons_pathes().pick_random()
	if val == null:
		return ""
	return get_new_weapons_pathes().pick_random()


func get_player_weapons() -> Array[String]:
	var weapons = RunGlobal.weapons
	var result: Array[String] = []
	for weapon in weapons:
		result.append(weapon.resource_path)
	return result


func switch_weapon(weapon_index: float):
	RunGlobal.replace_by_new_weapon(weapon_index, new_weapon_path)


func _on_switch_left_weapon_button_pressed() -> void:
	switch_weapon(weapon_indexes[0])
	new_weapon_chosen.emit()


func _on_switch_center_weapon_button_pressed() -> void:
	switch_weapon(weapon_indexes[1])
	new_weapon_chosen.emit()


func _on_switch_right_weapon_button_pressed() -> void:
	switch_weapon(weapon_indexes[2])
	new_weapon_chosen.emit()
