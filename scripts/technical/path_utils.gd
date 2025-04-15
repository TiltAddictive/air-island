extends Node2D
class_name PathUtils


static func get_weapon_image_path_and_title(index: int) -> Array[String]:
	return PathUtils.get_weapon_scene_image_path_and_title(RunGlobal.weapons[index])


static func get_weapon_scene_image_path_and_title(weapon_scene: PackedScene) -> Array[String]:
	if weapon_scene == null:
		return ["", ""]
	var temp_weapon = weapon_scene.instantiate()
	var sprite = temp_weapon.SPRITE_PATH
	var title = temp_weapon.TITLE_ID
	temp_weapon.queue_free()
	return [sprite, title]
