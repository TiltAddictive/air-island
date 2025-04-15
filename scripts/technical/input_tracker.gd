extends Node

enum InputTypes {
	KEYBOARD,
	GAMEPAD,
	NONE
}

var last_input_type: InputTypes = InputTypes.NONE

signal input_type_changed(new_type: String)


func _input(event: InputEvent) -> void:
	var new_type: InputTypes = InputTypes.NONE

	if event is InputEventKey and event.pressed:
		new_type = InputTypes.KEYBOARD

	elif event is InputEventJoypadButton and event.pressed:
		new_type = InputTypes.GAMEPAD

	elif event is InputEventJoypadMotion:
		new_type = InputTypes.GAMEPAD

	elif event is InputEventMouseButton and event.pressed:
		new_type = InputTypes.KEYBOARD

	elif event is InputEventMouseMotion:
		new_type = InputTypes.KEYBOARD

	# Если тип ввода изменился, уведомляем
	if new_type != InputTypes.NONE and new_type != last_input_type:
		last_input_type = new_type
		emit_signal("input_type_changed", new_type)
