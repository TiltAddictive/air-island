extends CharacterBody2D
class_name DefaultEnemy

# HP
@export var MAX_HP: float = 3
@onready var hp: float = MAX_HP


# Move
var direction: Vector2 = Vector2.ZERO
var look_at_direction: Vector2 = Vector2.RIGHT
@export var SPEED: float = 50


# Attack
@export var ENEMY_ATACK_NODE: Node2D = null
@onready var attack_area_2d: Area2D = $AttackAreaNode/AttackArea2D
@export var DAMAGE: float = 2


# Timers
@onready var attack_reload_timer: Timer = $Timers/AttackReloadTimer
@export var attack_reload_time: float = 2


var can_attack: bool = true
var can_get_damage: bool = true

var prev_player_position = Vector2.ZERO


func _ready() -> void:
	attack_reload_timer.wait_time = attack_reload_time


func _physics_process(delta: float) -> void:
	calc_death()
	calc_attack()


func calc_death() -> void:
	if hp <= 0:
		death()


func calc_attack():
	var bodies_to_attack_list = attack_area_2d.get_overlapping_bodies()
	for body in bodies_to_attack_list:
		attack(body)


func get_player_position() -> Vector2:
	return RunGlobal.get_closest_player(global_position).global_position


func death() -> void:
	queue_free()


func get_hit(damage: float, impulse: Vector2 = Vector2.ZERO) -> void:
	hp -= damage


func attack(body: Node2D) -> void:
	if can_attack and body.has_method("get_hit"):
		can_attack = false
		body.get_hit(DAMAGE)
		attack_reload_timer.start(attack_reload_time)

func _on_attack_reload_timer_timeout() -> void:
	can_attack = true
