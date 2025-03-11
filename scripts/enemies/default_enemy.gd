extends CharacterBody2D
class_name DefaultEnemy

@onready var animation_player: AnimationPlayer = $RotationalPart/Sprite/AnimationPlayer
@onready var death_animation_player: AnimationPlayer = $RotationalPart/DeathAnimationPlayer

# HP
@export var MAX_HP: float = 3
@onready var hp: float = MAX_HP
@onready var hp_bar: HPBar = $HPBar
var is_dying: bool = false


# Move
var direction: Vector2 = Vector2.ZERO
var look_at_direction: Vector2 = Vector2.RIGHT
@export var SPEED: float = 50


# Attack
@export var ENEMY_ATACK_NODE: Node2D = null
@onready var attack_area_2d: Area2D = $AttackAreaNode/AttackArea2D
@export var DAMAGE: float = 2
@export var REJECTION_FORCE_VALUE: float = 200


# Timers
@onready var attack_reload_timer: Timer = $Timers/AttackReloadTimer
@export var attack_reload_time: float = 2
@onready var calc_velocity_timer: Timer = $Timers/CalcVelocityTimer

@export var can_attack: bool = true
@export var can_get_damage: bool = true
var calc_velocity: bool = true

var prev_player_position = Vector2.ZERO

var prev_velocity_sign: int = 1
@onready var rotational_part: Node2D = $RotationalPart

var player_position: Vector2
@export var DISTANCE_TO_PLAYER_EPSILON: float = 10

@export var ROTATION_SPEED: float = 1200

@export var DEATH_SPEED: float = 150


func _ready() -> void:
	attack_reload_timer.wait_time = attack_reload_time


func _process(_delta: float) -> void:
	calc_rotation_scale()


func _physics_process(delta: float) -> void:
	calc_death()
	calc_attack()
	calc_move(delta)
	calc_animation()


func calc_animation():
	if velocity.length() != 0 and not is_dying:
		animation_player.play("move")
		return
	animation_player.stop()


func calc_death() -> void:
	if hp <= 0 and not is_dying:
		death()


func calc_attack():
	if not can_attack:
		return
	var bodies_to_attack_list = attack_area_2d.get_overlapping_bodies()
	for body in bodies_to_attack_list:
		attack(body)
	if bodies_to_attack_list.size() == 0:
		return
	attack_reload_timer.start()
	can_attack = false


func calc_move(_delta: float) -> void:
	pass


func get_player_position() -> Vector2:
	return RunGlobal.get_closest_player(global_position).global_position


func death() -> void:
	can_attack = false
	calc_velocity = false
	can_get_damage = false
	is_dying = true
	velocity = Vector2(-sign(velocity.x) * DEATH_SPEED, 0)
	animation_player.clear_queue()
	animation_player.stop()
	death_animation_player.play("death_animation", -1, 1.5)


func get_hit(damage: float, impulse: Vector2 = Vector2.ZERO, impulse_impact_time: float = 0) -> void:
	if not can_get_damage:
		return
	hp -= damage
	if not calc_velocity:
		return
	calc_velocity = false
	velocity += impulse
	calc_velocity_timer.start(impulse_impact_time)


func attack(body: Node2D) -> void:
	if can_attack and body.has_method("get_hit"):
		var impulse_vector_direction: Vector2 = (body.global_position - self.global_position).normalized() * REJECTION_FORCE_VALUE
		body.get_hit(DAMAGE, impulse_vector_direction)
		attack_reload_timer.start(attack_reload_time)


func calc_rotation_scale():
	if is_dying:
		return
	switch_rotational_scale()


func switch_rotational_scale():
	if sign(velocity.x) > 0:
		rotational_part.scale.x = 1
	elif sign(velocity.x) < 0:
		rotational_part.scale.x = -1


func _on_attack_reload_timer_timeout() -> void:
	if is_dying:
		can_attack = false
		return
	can_attack = true


func _on_calc_velocity_timer_timeout() -> void:
	if is_dying:
		return
	calc_velocity = true
