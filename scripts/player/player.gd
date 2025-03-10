extends CharacterBody2D

signal player_get_gamage

# Move
var direction: Vector2 = Vector2.ZERO
var look_at_direction: Vector2 = Vector2.RIGHT
@export var SPEED: float = 300


# Attack
@export var WEAPON_NODE: Node2D = null
@export var GET_DAMAGE_IMPULSE: float = 100

var can_attack: bool = true
var is_evaporated: bool = false
var can_get_damage: bool = true
var calc_input: bool = true


# Timers
@onready var invulnerability_timer: Timer = $Timers/InvulnerabilityTimer
@export var invulnerability_time: float = 0.6
@onready var input_reload_timer: Timer = $Timers/InputReloadTimer
@export var input_reload_time: float = 0.3

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
	calc_velocity()
	calc_animation()
	move_and_slide()


func calc_velocity():
	if not calc_input and not can_get_damage:
		return
	velocity = direction * SPEED * RunGlobal.SPEED_MULTIPLIER

func get_input():
	if not calc_input:
		return
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	look_at_direction = direction if direction != Vector2.ZERO else look_at_direction


func get_hit(damage: float, impulse: Vector2 = Vector2.ZERO) -> void:
	if not can_get_damage:
		return
	RunGlobal.player_hp -= 1
	can_get_damage = false
	invulnerability_timer.start(
		invulnerability_time * RunGlobal.INVULNERABILITY_TIME_MULTIPLIER
	)
	stun(input_reload_time)
	velocity = impulse.normalized() * GET_DAMAGE_IMPULSE
	player_get_gamage.emit(damage, impulse)


func calc_attack():
	if Input.is_action_just_pressed("attack") and can_attack and WEAPON_NODE:
		launch_weapon()


func launch_weapon():
	var weapon_scene = RunGlobal.launch_current_weapon()
	if weapon_scene == null:
		return
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
	can_get_damage = false
	invulnerability_timer.start(
		invulnerability_time * RunGlobal.INVULNERABILITY_TIME_MULTIPLIER
	)
	global_position = spawn_position
	velocity = Vector2.ZERO
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

func stun(duration: float = -1):
	if duration < 0:
		duration = input_reload_time
	calc_input = false
	can_attack = false
	input_reload_timer.start(duration)

func _on_invulnerability_timer_timeout() -> void:
	can_get_damage = true


func _on_input_reload_timer_timeout() -> void:
	calc_input = true
	can_attack = true
