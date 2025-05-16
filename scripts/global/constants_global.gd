extends Node

signal sound_value_changed
signal music_value_changed

const AVAILABLE_LANGUAGES = {
	EN = "en",
	RU = "ru",
}
var VELOCITY_EPS: float = 0.05

var SOUND_VALUE: int = 5:
	set = set_sound_value

var MUSIC_VALUE: int = 5:
	set = set_music_value

var languages: Array[String]
var current_language_index: int = 0

const SETTINGS_FILE: String = "user://settings.cfg"

func _ready() -> void:
	languages = []
	for key in ConstantsGlobal.AVAILABLE_LANGUAGES.keys():
		languages.append(key)
	load_settings()
	TranslationServer.set_locale(AVAILABLE_LANGUAGES[languages[current_language_index]])


func clear_node(node: Node):
	for child in node.get_children():
		child.queue_free()


func get_current_language():
	return languages[current_language_index]


func switch_language():
	current_language_index = (current_language_index + 1) % languages.size()
	TranslationServer.set_locale(AVAILABLE_LANGUAGES[languages[current_language_index]])


# Сохранение настроек
func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "sound_value", SOUND_VALUE)
	config.set_value("audio", "music_value", MUSIC_VALUE)
	config.set_value("language", "current_language_index", current_language_index)

	var error = config.save(SETTINGS_FILE)
	if error != OK:
		print("Ошибка при сохранении настроек: ", error)

# Загрузка настроек
func load_settings():
	var config = ConfigFile.new()
	var error = config.load(SETTINGS_FILE)
	if error != OK:
		print("Файл настроек не найден или поврежден. Используются значения по умолчанию.")
	else:
		SOUND_VALUE = config.get_value("audio", "sound_value", SOUND_VALUE)
		MUSIC_VALUE = config.get_value("audio", "music_value", MUSIC_VALUE)
		current_language_index = config.get_value("language", "current_language_index", current_language_index)


func set_sound_value(value: int) -> void:
	SOUND_VALUE = value
	sound_value_changed.emit(SOUND_VALUE)

func set_music_value(value: int) -> void:
	MUSIC_VALUE = value
	music_value_changed.emit(MUSIC_VALUE)
