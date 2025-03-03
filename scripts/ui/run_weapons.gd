extends Control

@onready var left_weapon_icon: TextureRect = $HBoxContainer/WeaponIconLeft
@onready var left_weapon_cooldown: Label = $HBoxContainer/WeaponIconLeft/WeaponCooldownLeft

@onready var center_weapon_icon: TextureRect = $HBoxContainer/WeaponIconCenter
@onready var center_weapon_cooldown: Label = $HBoxContainer/WeaponIconCenter/WeaponCooldownCenter

@onready var right_weapon_icon: TextureRect = $HBoxContainer/WeaponIconRight
@onready var right_weapon_cooldown: Label = $HBoxContainer/WeaponIconRight/WeaponCooldownRight
var weapon_indexes: Array[int] = []


func _ready() -> void:
	update_weapon_display()
	RunGlobal.weapon_switched.connect(update_weapon_display)

func _process(delta: float) -> void:
	update_timers_labels(weapon_indexes[0], weapon_indexes[1], weapon_indexes[2])

func update_weapon_indexes():
	var center_index: int = RunGlobal.current_weapon_index
	var left_index: int = RunGlobal.get_changed_index(
		RunGlobal.weapons,
		center_index - 1
	)
	var right_index: int = RunGlobal.get_changed_index(
		RunGlobal.weapons,
		center_index + 1
	)
	weapon_indexes = [left_index, center_index, right_index]
	

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
	left_weapon_icon.texture = load(get_weapon_image_path(left_index))
	center_weapon_icon.texture = load(get_weapon_image_path(center_index))
	right_weapon_icon.texture = load(get_weapon_image_path(right_index))


func get_weapon_image_path(index: int) -> String:
	var temp_weapon = RunGlobal.weapons[index].instantiate()
	var sprite = temp_weapon.SPRITE.texture.resource_path
	temp_weapon.queue_free()
	return sprite
