extends Control

@onready var left_weapon_icon: TextureRect = $MarginContainer/HBoxContainer/LeftWeaponVBox/WeaponIconLeft
@onready var left_weapon_cooldown: Label = $MarginContainer/HBoxContainer/LeftWeaponVBox/WeaponCooldownLeft

@onready var center_weapon_icon: TextureRect = $MarginContainer/HBoxContainer/CenterWeaponVBox/WeaponIconCenter
@onready var center_weapon_cooldown: Label = $MarginContainer/HBoxContainer/CenterWeaponVBox/WeaponCooldownCenter

@onready var right_weapon_icon: TextureRect = $MarginContainer/HBoxContainer/RightWeaponVBox/WeaponIconRight
@onready var right_weapon_cooldown: Label = $MarginContainer/HBoxContainer/RightWeaponVBox/WeaponCooldownRight
var weapon_indexes: Array[int] = [0, 0, 0]


func _ready() -> void:
	update_weapon_display()
	RunGlobal.weapon_switched.connect(update_weapon_display)

func _process(delta: float) -> void:
	update_timers_labels(weapon_indexes[0], weapon_indexes[1], weapon_indexes[2])

func update_weapon_indexes():
	weapon_indexes = RunGlobal.get_weapon_indexes()

func update_weapon_display():
	update_weapon_indexes()
	update_timers_labels(weapon_indexes[0], weapon_indexes[1], weapon_indexes[2])
	update_icons(weapon_indexes[0], weapon_indexes[1], weapon_indexes[2])


func update_timers_labels(left_index: int = 0, center_index: int = 1, right_index: int = 2):
	update_timer_label(left_weapon_cooldown, left_index)
	update_timer_label(center_weapon_cooldown, center_index)
	update_timer_label(right_weapon_cooldown, right_index)


func update_timer_label(timer_label: Label, index: int):
	var timer: Timer = RunGlobal.weapon_timers[index]
	var result: float = timer.time_left
	if result == 0:
		result = timer.wait_time
	timer_label.text = "%.2f" % result


func update_icons(left_index: int = 0, center_index: int = 1, right_index: int = 2):
	left_weapon_icon.texture = load(PathUtils.get_weapon_image_path_and_title(left_index)[0])
	center_weapon_icon.texture = load(PathUtils.get_weapon_image_path_and_title(center_index)[0])
	right_weapon_icon.texture = load(PathUtils.get_weapon_image_path_and_title(right_index)[0])
