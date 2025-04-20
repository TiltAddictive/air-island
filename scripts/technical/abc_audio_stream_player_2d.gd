extends AudioStreamPlayer2D
class_name CustomAudioStreamPlayer2D

@export var is_music: bool = false
@export var sound_multiplier: float = 1
@export var restart_after_finished: bool = false

func _ready() -> void:
	ConstantsGlobal.connect("sound_value_changed", sound_value_changed)
	ConstantsGlobal.connect("music_value_changed", music_value_changed)


func custom_play(from_position: float = 0.0) -> void:
	volume_db = calc_volume_db()
	play(from_position)


func _on_finished() -> void:
	if restart_after_finished:
		custom_play()


func get_global_volume() -> float:
	return ConstantsGlobal.MUSIC_VALUE if is_music else ConstantsGlobal.SOUND_VALUE


func calc_volume_db() -> float:
	return lerp(-40.0, 0.0, sound_multiplier * float(get_global_volume() / 10.0))


func sound_value_changed(value: int) -> void:
	volume_db = calc_volume_db()


func music_value_changed(value: int) -> void:
	volume_db = calc_volume_db()
