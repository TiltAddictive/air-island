extends Control

signal new_weapon_chosen

@onready var new_weapon_icon: TextureRect = $BlurLayer/VBoxContainer/NewWeaponContainer/NewWeaponCard/NewWeaponIcon
@onready var new_weapon_name_label: Label = $BlurLayer/VBoxContainer/NewWeaponContainer/NewWeaponCard/NewWeaponNameLabel
@onready var weapon_path_util: WeaponPathUtil = WeaponPathUtil.new()

var new_weapon: PackedScene
var weapon_indexes
var new_weapon_info

func _ready() -> void:
	update()

func update() -> void:
	update_current_weapons_images()
	update_new_weapon_image()
	localize_text()
	$BlurLayer/VBoxContainer/CurrentWeaponsHBoxContainer/CenterWeaponCard/SwitchCenterWeaponButton.grab_focus()

func localize_text():
	$BlurLayer/VBoxContainer/CurrentWeaponsHBoxContainer/LeftWeaponCard/SwitchLeftWeaponButton.text = tr("replaceWeapon")
	$BlurLayer/VBoxContainer/CurrentWeaponsHBoxContainer/CenterWeaponCard/SwitchCenterWeaponButton.text = tr("replaceWeapon")
	$BlurLayer/VBoxContainer/CurrentWeaponsHBoxContainer/RightWeaponCard/SwitchRightWeaponButton.text = tr("replaceWeapon")


func update_current_weapons_images():
	weapon_indexes = RunGlobal.get_weapon_indexes()
	var left_weapon_info = PathUtils.get_weapon_image_path_and_title(weapon_indexes[0])
	var center_weapon_info = PathUtils.get_weapon_image_path_and_title(weapon_indexes[1])
	var right_weapon_info = PathUtils.get_weapon_image_path_and_title(weapon_indexes[2])
	$BlurLayer/VBoxContainer/CurrentWeaponsHBoxContainer/LeftWeaponCard/LeftWeaponIcon.texture = load(left_weapon_info[0])
	$BlurLayer/VBoxContainer/CurrentWeaponsHBoxContainer/LeftWeaponCard/LeftWeaponTitle.text = tr(left_weapon_info[1])
	$BlurLayer/VBoxContainer/CurrentWeaponsHBoxContainer/CenterWeaponCard/CenterWeaponIcon.texture = load(center_weapon_info[0])
	$BlurLayer/VBoxContainer/CurrentWeaponsHBoxContainer/CenterWeaponCard/CenterWeaponTitle.text = tr(center_weapon_info[1])
	$BlurLayer/VBoxContainer/CurrentWeaponsHBoxContainer/RightWeaponCard/RightWeaponIcon.texture = load(right_weapon_info[0])
	$BlurLayer/VBoxContainer/CurrentWeaponsHBoxContainer/RightWeaponCard/RightWeaponTitle.text = tr(right_weapon_info[1])


func update_new_weapon_image():
	new_weapon = weapon_path_util.get_new_weapon()
	new_weapon_info = PathUtils.get_weapon_scene_image_path_and_title(new_weapon)
	new_weapon_icon.texture = load(
		new_weapon_info[0]
	)
	new_weapon_name_label.text = tr(new_weapon_info[1])


func switch_weapon(weapon_index: int) -> void:
	if weapon_index < 0 or weapon_index >= RunGlobal.weapons.size():
		return
	if new_weapon == null:
		print("New weapon is null")
		return
	RunGlobal.replace_by_new_weapon(weapon_index, new_weapon)


func _on_switch_left_weapon_button_pressed() -> void:
	switch_weapon(weapon_indexes[0])
	new_weapon_chosen.emit()


func _on_switch_center_weapon_button_pressed() -> void:
	switch_weapon(weapon_indexes[1])
	new_weapon_chosen.emit()


func _on_switch_right_weapon_button_pressed() -> void:
	switch_weapon(weapon_indexes[2])
	new_weapon_chosen.emit()
