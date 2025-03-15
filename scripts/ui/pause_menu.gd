extends Control


@export var main_level: Node

func _on_continue_button_pressed() -> void:
	main_level.toggle_pause()


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_to_main_menu_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_game_button_pressed() -> void:
	get_tree().quit()
