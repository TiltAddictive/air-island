extends Node2D
class_name PathUtils


static func get_scenes_from_path(path: String) -> Array[String]:
	print("get_scenes_from_path")
	if not DirAccess.dir_exists_absolute(path):
		print("if not DirAccess.dir_exists_absolute(path):")
		return []
	var dir = DirAccess.open(path)

	if dir == null:
		print("Не удалось открыть папку:", path)
		return []

	var scenes: Array[String] = []

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tscn"):
			scenes.append(path + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	return scenes


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
