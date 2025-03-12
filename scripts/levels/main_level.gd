extends Node2D

@export var level_generator: Node2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Allies/Player
@onready var enemy_wave_manager: EnemyWaveManager = $Technical/EnemyWaveManager
@onready var switch_weapon_ui: Control = $CanvasLayer/SwitchWeaponUI
@onready var wave_manager_ui: Control = $CanvasLayer/WaveManagerUI

@onready var run_progress_data: RunProgressData = RunProgressData.new()

func _ready():
	RunGlobal.new_run()
	enemy_wave_manager.connect("wave_ends", wave_ends)
	enemy_wave_manager.connect("wave_starts", wave_starts)
	enemy_wave_manager.connect("stage_ends", stage_ends)
	level_generator.connect("level_is_cleared", generate_level)
	switch_weapon_ui.connect("new_weapon_chosen", hide_switch_weapon_menu)
	RunGlobal.WEAPON_NODE = $Weapons
	RunGlobal.ENEMY_WAVE_MANAGER_NODE = $Technical/EnemyWaveManager
	RunGlobal.player_run_out_of_hp.connect(player_died)
	player.connect("player_removed_from_tree", run_ends)
	new_stage()
	run_progress_data.save_run()


func new_stage(stun: bool = true):
	if stun:
		player.freeze(2)
	RunGlobal.player_hp += 1
	level_generator.clear_level()


func generate_level(amount: int = 20):
	level_generator.generate_level(amount)


func _process(delta: float) -> void:
	calc_choose_weapon_input()


func calc_choose_weapon_input():
	var weapon_input = 0
	if Input.is_action_just_pressed("choose_left"):
		weapon_input = -1

	if Input.is_action_just_pressed("choose_right"):
		weapon_input = 1

	if weapon_input == 0:
		return
	RunGlobal.swith_weapon(sign(weapon_input))


func player_died():
	get_tree().paused = true
	camera_2d.zoom_camera_on_player()


func run_ends():
	enemy_wave_manager.waiting = false
	get_tree().paused = false
	get_tree().reload_current_scene()


func wave_starts(wave_num: int):
	wave_manager_ui.start_new_wave_animation()
	
func wave_ends(wave_ends_num: int, waves_amount: int):
	if wave_ends_num != waves_amount:
		return
	show_switch_weapon_menu()

func show_switch_weapon_menu():
	get_tree().paused = true
	switch_weapon_ui.update()
	switch_weapon_ui.visible = true
	player.freeze()


func hide_switch_weapon_menu():
	switch_weapon_ui.visible = false
	get_tree().paused = false
	player.calc_input = true


func stage_ends(current_stage: int, stages_amount: int):
	if current_stage == stages_amount:
		run_ends()
		return
	new_stage(2)
	enemy_wave_manager.waiting = false
	enemy_wave_manager.start()
