extends Control

@export var enemies_wave_manager: Node2D
@onready var wave_counter_label: Label = $MarginContainer/HBoxContainer/WaveCounter
@onready var new_wave_label: Label = $MarginContainer/NewWaveLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(delta: float) -> void:
	wave_counter_label.text = tr("wave_count_text") % [enemies_wave_manager.current_stage, enemies_wave_manager.stages_amount, enemies_wave_manager.current_wave, enemies_wave_manager.waves_amount]


func start_new_wave_animation() -> void:
	new_wave_label.text = tr("new_wave_text") % [enemies_wave_manager.current_wave, enemies_wave_manager.waves_amount]
	animation_player.play("new_wave")
