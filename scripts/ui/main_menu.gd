extends Control

@onready var run_progress_data: RunProgressData = RunProgressData.new()
const MAIN_LEVEL = preload("res://scenes/levels/main_level.tscn")

func _ready() -> void:
	load_localization()
	print("Main Menu loaded!")
	$BlurLayer/CenterContainer/VBoxContainer/ContinueRunButton.grab_focus()
	if run_progress_data.check_save_files_exists():
		return
	$BlurLayer/CenterContainer/VBoxContainer/ContinueRunButton.disabled = true
	$BlurLayer/CenterContainer/VBoxContainer/NewRunButton.grab_focus()


func load_localization():
	$BlurLayer/CenterContainer/VBoxContainer/ContinueRunButton.text = tr("continue_button_text")
	$BlurLayer/CenterContainer/VBoxContainer/NewRunButton.text = tr("new_run_button_text")
	$BlurLayer/CenterContainer/VBoxContainer/SettingsButton.text = tr("settings_button_text")
	$BlurLayer/CenterContainer/VBoxContainer/ExitGameButton.text = tr("exit_game_button_text")


func _on_continue_run_button_pressed() -> void:
	print("_on_continue_run_button_pressed")
	SceneController.change_scene(SceneController.MAIN_LEVEL)


func _on_new_run_button_pressed() -> void:
	print("_on_new_run_button_pressed")
	run_progress_data.delete_save_file()
	SceneController.change_scene(SceneController.MAIN_LEVEL)


func _on_settings_button_pressed() -> void:
	SceneController.open_above_the_current_scene(ConstantsGlobal.SETTINGS_SCENE_PATH, $BlurLayer/CenterContainer, $BlurLayer, self, "_on_settings_window_closed")


func _on_exit_game_button_pressed() -> void:
	SceneController.quit_game()


func _on_settings_window_closed():
	load_localization()
	$BlurLayer/CenterContainer/VBoxContainer/SettingsButton.grab_focus()
