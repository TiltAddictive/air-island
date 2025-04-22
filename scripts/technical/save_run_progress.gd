extends Resource
class_name RunProgressData

var save_file_path = "user://save/"
var save_file_name = "save_progress.json"

func _ready() -> void:
	verify_save_directory(save_file_path)


func save_run():
	verify_save_directory(save_file_path)
	var save_data = {
		"player_hp": RunGlobal.player_hp,
		"player_max_hp": RunGlobal.player_max_hp,
		"weapons": get_weapon_pathes(),
		"waves_amount": RunGlobal.ENEMY_WAVE_MANAGER_NODE.waves_amount,
		"current_wave": RunGlobal.ENEMY_WAVE_MANAGER_NODE.current_wave,
		"stages_amount": RunGlobal.ENEMY_WAVE_MANAGER_NODE.stages_amount,
		"current_stage": RunGlobal.ENEMY_WAVE_MANAGER_NODE.current_stage
	}
	
	var file = FileAccess.open(save_file_path + save_file_name, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Game saved successfully!")
	else:
		print("Failed to save the game.")
		print(file)
	debug_print_save_file()

func check_save_files_exists() -> bool:
	if FileAccess.file_exists(save_file_path + save_file_name):
		return true
	print("No save file found!")
	return false


func load_game() -> bool:
	if not check_save_files_exists():
		return false

	var file = FileAccess.open(save_file_path + save_file_name, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	if json.parse(json_string) != OK:
		print("Failed to parse save file.")

	var save_data = json.get_data()
	load_from_json(save_data)
	print("Save file loaded successfully")
	return true


func load_from_json(save_data):
	var loaded_weapons: Array[PackedScene] = []
	for path in save_data["weapons"]:
		var scene = load(path)
		if scene:
			loaded_weapons.append(scene)
	RunGlobal.weapons = loaded_weapons
	RunGlobal.player_max_hp = save_data["player_max_hp"]
	RunGlobal.player_hp = save_data["player_hp"]
	RunGlobal.ENEMY_WAVE_MANAGER_NODE.stages_amount = save_data["stages_amount"]
	RunGlobal.ENEMY_WAVE_MANAGER_NODE.current_stage = save_data["current_stage"]


func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)


func delete_save_file():
	print("try to delete save file")
	var path = save_file_path + save_file_name
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		print("Save file deleted.")
	else:
		print("No save file to delete.")


func get_weapon_pathes() -> Array[String]:
	var result: Array[String] = []
	for weapon in RunGlobal.weapons:
		result.append(weapon.resource_path)
	return result


func debug_print_save_file():
	if FileAccess.file_exists(save_file_path + save_file_name):
		var file = FileAccess.open(save_file_path + save_file_name, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		print("Save file content:\n", content)
	else:
		print("No save file found.")
