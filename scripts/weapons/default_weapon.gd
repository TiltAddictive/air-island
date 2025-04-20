extends CharacterBody2D
class_name DefaultWeapon

signal weapon_collided_with_wall
signal weapon_have_to_destroy

# Timers
@onready var collision_response_timer: Timer = $Timers/CollisionResponseTimer
@export var collision_response_time: float = 0.05
@export var RELOAD_TIME: float = 1.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var rotational_part: Node2D = $RotationalPart

# Movement
@export var SPEED: float = 400
var direction: Vector2 = Vector2(1, 1)

# Damage
@export var DAMAGE: float = 2
@export var REJECTION_FORCE_VALUE: float = 0
@export var IMPULSE_IMPACT_TIME: float = 1

# Behaviour
var BEHAVIOUR: Dictionary
var have_to_response_on_collision: bool = false

# Player
var PLAYER: CharacterBody2D

@export var SPRITE_PATH: String
@export var TITLE_ID: String = "classic"

func set_weapon_behaviour_states():
	pass

func _ready():
	set_weapon_behaviour_states()
	set_timers_times()
	run_timers()


func set_timers_times():
	collision_response_timer.wait_time = collision_response_time


func run_timers():
	collision_response_timer.start()


func restart_collision_response_waiting():
	have_to_response_on_collision = false
	collision_response_timer.start()


func _on_collision_response_timer_timeout() -> void:
	have_to_response_on_collision = true 


func destroy(damage: float = 0, impulse_vector_direction: Vector2 = Vector2.ZERO, weapon_broke: bool = false):
	RunGlobal.PLAYER.restore(global_position, damage, impulse_vector_direction, weapon_broke)
	RunGlobal.WEAPON_PLAYER = null
	queue_free()


func get_hit(damage: float, impulse: Vector2 = Vector2.ZERO) -> void:
	destroy(damage, impulse, true)


func _on_weapon_have_to_destroy() -> void:
	destroy()


func _on_weapon_collided_with_wall() -> void:
	pass
