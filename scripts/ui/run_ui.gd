extends Control

@onready var weapon_index: Label = $WeaponIndex

func _process(delta: float) -> void:
	weapon_index.text = str(RunGlobal.current_weapon_index)
