extends Node


const AVAILABLE_LANGUAGES = {
	EN = "en",
	RU = "ru",
}
var VELOCITY_EPS: float = 0.05

var SOUND_VALUE: int = 5
var MUSIC_VALUE: int = 5
var SETTINGS_SCENE_PATH: String = "res://scenes/UI/settings_menu.tscn"
var languages: Array[String]
var current_language_index: int = 0

func _ready() -> void:
	languages = []
	for key in ConstantsGlobal.AVAILABLE_LANGUAGES.keys():
		languages.append(key)
	TranslationServer.set_locale(AVAILABLE_LANGUAGES.EN)
	switch_language()


func clear_node(node: Node):
	for child in node.get_children():
		child.queue_free()


func get_current_language():
	return languages[current_language_index]


func switch_language():
	current_language_index = (current_language_index + 1) % languages.size()
	print("languages[current_language_index] ", languages[current_language_index])
	TranslationServer.set_locale(AVAILABLE_LANGUAGES[languages[current_language_index]])
