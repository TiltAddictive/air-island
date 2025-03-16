extends Control

signal closed
@export var called_node: Node


func _ready():
	called_node.visible = false
	$VBoxContainer/GridContainer/HSlider.grab_focus()
	set_locales()


func set_locales():
	$VBoxContainer/GridContainer/SoundLabel.text = tr("sounds_volume")
	$VBoxContainer/GridContainer/MusicLabel.text = tr("music_volume")
	$VBoxContainer/GridContainer/LanguageLabel.text = tr("language")
	$VBoxContainer/GridContainer/ChangeLanguageButton.text = ConstantsGlobal.get_current_language()
	$VBoxContainer/HBoxContainer/SaveAndExit.text = tr("save_and_quit")


func _on_change_language_button_pressed() -> void:
	ConstantsGlobal.switch_language()
	set_locales()


func _on_save_and_exit_pressed() -> void:
	called_node.visible = true
	closed.emit()
	queue_free()
