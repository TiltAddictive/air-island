extends Control

@onready var left_weapon_icon: TextureRect = $HBoxContainer/WeaponIconLeft
@onready var center_weapon_icon: TextureRect = $HBoxContainer/WeaponIconCenter
@onready var right_weapon_icon: TextureRect = $HBoxContainer/WeaponIconRight


func _ready() -> void:
	update_weapon_display()
	RunGlobal.weapon_switched.connect(update_weapon_display)


func update_timers():
	pass

func update_weapon_display():
	var center_index = RunGlobal.current_weapon_index
	var left_index = RunGlobal.get_changed_index(
		RunGlobal.weapons,
		center_index - 1
	)
	var right_index = RunGlobal.get_changed_index(
		RunGlobal.weapons,
		center_index + 1
	)

	update_icons(left_index, center_index, right_index)

func update_icons(left_index: int = 0, center_index: int = 1, right_index: int = 2):
	left_weapon_icon.texture = load(get_weapon_image_path(left_index))
	center_weapon_icon.texture = load(get_weapon_image_path(center_index))
	right_weapon_icon.texture = load(get_weapon_image_path(right_index))


func get_weapon_image_path(index: int) -> String:
	var temp_weapon = RunGlobal.weapons[index].instantiate()
	var sprite = temp_weapon.SPRITE.texture.resource_path
	temp_weapon.queue_free()
	return sprite
