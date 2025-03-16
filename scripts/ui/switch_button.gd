extends Control

@onready var button_sprite: Sprite2D = $CenterContainer/ButtonSprite
@export var right: bool = true


func _process(delta: float) -> void:
	if right:
		return set_right()
	set_left()


func set_left():
	var lst_inp_type: InputTracker.InputTypes = InputTracker.last_input_type
	if lst_inp_type == InputTracker.InputTypes.KEYBOARD:
		button_sprite.frame = 0
	if lst_inp_type == InputTracker.InputTypes.GAMEPAD:
		button_sprite.frame = 2


func set_right():
	var lst_inp_type: InputTracker.InputTypes = InputTracker.last_input_type
	if lst_inp_type == InputTracker.InputTypes.KEYBOARD:
		button_sprite.frame = 1
	if lst_inp_type == InputTracker.InputTypes.GAMEPAD:
		button_sprite.frame = 3
