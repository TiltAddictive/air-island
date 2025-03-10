extends Control

@onready var hearts_container: HBoxContainer = $HeartsContainer
var hp_heart_scene: PackedScene = preload("res://scenes/player/player_hp_heart.tscn")
var hearts: Array[Node]

func _ready():
	load_hearts()
	hearts = hearts_container.get_children()

func _process(delta: float) -> void:
	update_hearts()

func load_hearts():
	if hearts_container.get_child_count() == RunGlobal.player_max_hp:
		return
	for child in hearts_container.get_children():
		hearts_container.remove_child(child)
	for i in range(RunGlobal.player_max_hp):
		var hp_heart_node = hp_heart_scene.instantiate()
		hearts_container.add_child(hp_heart_node)


func update_hearts():
	if RunGlobal.player_hp < 0:
		return
	if hearts_container.get_child_count() != RunGlobal.player_max_hp:
		return
	for i in range(RunGlobal.player_hp):
		hearts[i].make_full()
	for i in range(RunGlobal.player_max_hp - RunGlobal.player_hp):
		hearts[RunGlobal.player_hp + i].make_empty()
