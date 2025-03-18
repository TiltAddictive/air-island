extends Control

signal closed
@export var called_node: Node
@onready var sound_h_slider: HSlider = $VBoxContainer/GridContainer/SoundHSlider
@onready var music_h_slider: HSlider = $VBoxContainer/GridContainer/MusicHSlider


func _ready():
	called_node.visible = false
	sound_h_slider.grab_focus()
	set_locales()
	sound_h_slider.value = min(ConstantsGlobal.SOUND_VALUE, sound_h_slider.max_value)
	music_h_slider.value = min(ConstantsGlobal.MUSIC_VALUE, music_h_slider.max_value)


func set_locales():
	$VBoxContainer/SettingsLabel.text = tr("settings_button_text")
	$VBoxContainer/GridContainer/SoundLabel.text = tr("sounds_volume")
	$VBoxContainer/GridContainer/MusicLabel.text = tr("music_volume")
	$VBoxContainer/GridContainer/LanguageLabel.text = tr("language")
	$VBoxContainer/GridContainer/ChangeLanguageButton.text = ConstantsGlobal.get_current_language()
	$VBoxContainer/HBoxContainer/SaveAndExit.text = tr("save_and_quit")


func _on_change_language_button_pressed() -> void:
	ConstantsGlobal.switch_language()
	set_locales()


func _on_save_and_exit_pressed() -> void:
	ConstantsGlobal.save_settings()
	called_node.visible = true
	closed.emit()
	queue_free()


func _on_sound_h_slider_value_changed(value: float) -> void:
	print("_on_sound_h_slider_value_changed")
	ConstantsGlobal.SOUND_VALUE = sound_h_slider.value


func _on_music_h_slider_value_changed(value: float) -> void:
	print("_on_music_h_slider_value_changed")
	ConstantsGlobal.MUSIC_VALUE = music_h_slider.value
