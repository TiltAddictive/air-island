extends Camera2D


@export var PLAYER_NODE: CharacterBody2D

func zoom_camera_on_player():
	var player: CharacterBody2D = RunGlobal.get_closest_player(global_position)
	if player == null:
		return

	var target_pos = player.global_position
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	tween.tween_property(self, "global_position", target_pos, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "zoom", Vector2(2, 2), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(_on_tween_finished)


func _on_tween_finished():
	PLAYER_NODE.start_death_animation()
