extends CharacterBody2D

signal player_get_gamage

# Move
var direction: Vector2 = Vector2.ZERO
var look_at_direction: Vector2 = Vector2.RIGHT
@export var SPEED: float = 300


# Attack
@export var WEAPON_NODE: Node2D = null

var can_attack: bool = true
var is_evaporated: bool = false
var can_get_damage: bool = true


# Timers
@onready var invulnerability_timer: Timer = $Timers/InvulnerabilityTimer
@export var invulnerability_time: float = 1

@onready var rotational_part: Node2D = $RotationalPart

@onready var animation_player: AnimationPlayer = $RotationalPart/Sprite2D/AnimationPlayer

func _ready() -> void:
	RunGlobal.PLAYER = self


func _process(delta: float) -> void:
	switch_rotational_scale()


func _physics_process(delta: float) -> void:
	if is_evaporated:
		global_position = RunGlobal.WEAPON_PLAYER.global_position
		return

	get_input()
	calc_attack()
	velocity = direction * SPEED * RunGlobal.SPEED_MULTIPLIER
	calc_animation()
	move_and_slide()


func get_input():
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	look_at_direction = direction if direction != Vector2.ZERO else look_at_direction


func get_hit(damage: float, impulse: Vector2 = Vector2.ZERO) -> void:
	if not can_get_damage:
		return
	can_get_damage = false
	invulnerability_timer.start(
		invulnerability_time * RunGlobal.INVULNERABILITY_TIME_MULTIPLIER
	)
	print("player_get_gamage.emit(",damage,", ", impulse, ")")
	player_get_gamage.emit(damage, impulse)


func calc_attack():
	if Input.is_action_just_pressed("attack") and can_attack and WEAPON_NODE:
		launch_weapon()


func launch_weapon():
	var weapon_scene = RunGlobal.weapons[RunGlobal.current_weapon_index].instantiate()
	weapon_scene.global_position = global_position
	weapon_scene.direction = look_at_direction
	WEAPON_NODE.add_child(weapon_scene)
	start_evaporating()


func start_evaporating():
	if is_evaporated:
		return
	is_evaporated = true
	can_get_damage = false
	can_attack = false

	set_physics_process(false)  # Отключаем физическую обработку (перемещения и коллизии)
	visible = false


func restore(spawn_position: Vector2, damage: float = 0):
	if not is_evaporated:
		return
	#velocity = restore_direction.normalized() * impulse
	#velocity.x = abs(velocity.x) if is_moving_right else -abs(velocity.x)
	global_position = spawn_position
	is_evaporated = false
	visible = true
	can_attack = true
	set_physics_process(true)


func calc_animation():
	if velocity.length() != 0:
		animation_player.play("move")
		return
	animation_player.stop()


func switch_rotational_scale():
	if sign(velocity.x) > 0:
		rotational_part.scale.x = 1
	elif sign(velocity.x) < 0:
		rotational_part.scale.x = -1


func _on_invulnerability_timer_timeout() -> void:
	can_get_damage = true
