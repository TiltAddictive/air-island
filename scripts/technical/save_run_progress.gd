extends Resource
class_name RunProgressData

var save_file_path = "user://save/"
var save_file_name = "RunProgressData.tres"

func _ready() -> void:
	verify_save_directory(save_file_path)

#@export var waves_amount: int = 1
#@export var current_wave: int = 1
#@export var stages_amount: int = 2
#@export var current_stage: int = 1

func save_run():
	verify_save_directory(save_file_path)
	var save_data = {
		"player_hp": RunGlobal.player_hp,
		"player_max_hp": RunGlobal.player_max_hp,
		"player_position": RunGlobal.PLAYER.global_position,
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
	load_game()


func load_game():
	if not FileAccess.file_exists(save_file_path + save_file_name):
		print("No save file found!")
		return

	var file = FileAccess.open(save_file_path + save_file_name, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	if json.parse(json_string) != OK:
		print("Failed to parse save file.")

	var save_data = json.get_data()
	print("SAVE_DATA: ", save_data)
	var loaded_weapons: Array[PackedScene] = []
	for path in save_data["weapons"]:
		var scene = load(path)
		if scene:
			loaded_weapons.append(scene)
	RunGlobal.weapons = loaded_weapons
	print("Weapons loaded: ", RunGlobal.weapons)


func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)


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
