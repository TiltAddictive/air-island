extends Control


@export var main_level: Node

func _ready() -> void:
	$BlurLayer/CenterContainer/VBoxContainer/ContinueButton.text = tr("continue_button_text")
	$BlurLayer/CenterContainer/VBoxContainer/SettingsButton.text = tr("settings_button_text")
	$BlurLayer/CenterContainer/VBoxContainer/ToMainMenuButton.text = tr("to_main_menu_button_text")
	$BlurLayer/CenterContainer/VBoxContainer/ExitGameButton.text = tr("exit_game_button_text")


func _physics_process(delta: float) -> void:
	calc_pause()


func _on_continue_button_pressed() -> void:
	main_level.toggle_pause()


func _on_settings_button_pressed() -> void:
	SceneController.open_above_the_current_scene(ConstantsGlobal.SETTINGS_SCENE_PATH, $BlurLayer/CenterContainer, $BlurLayer, self, "_on_settings_window_closed")


func _on_to_main_menu_button_pressed() -> void:
	main_level.toggle_pause()
	SceneController.change_scene(SceneController.MAIN_MENU)


func _on_exit_game_button_pressed() -> void:
	get_tree().quit()


func calc_pause():
	if Input.is_action_just_pressed("ui_pause"):
		main_level.toggle_pause()
		$BlurLayer/CenterContainer/VBoxContainer/ContinueButton.grab_focus()


func _on_settings_window_closed():
	$BlurLayer/CenterContainer/VBoxContainer/SettingsButton.grab_focus()
