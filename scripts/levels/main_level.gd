extends Node2D

@export var level_generator: Node2D

func _ready():
	level_generator.generate_level(15)
	$Allies/Player.stun()
	RunGlobal.WEAPON_NODE = $Weapons
	


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
