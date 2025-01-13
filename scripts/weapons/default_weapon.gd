extends CharacterBody2D
class_name DefaultWeapon

signal weapon_collided_with_wall
signal weapon_have_to_destroy

# Timers
@onready var collision_response_timer: Timer = $Timers/CollisionResponseTimer
@export var collision_response_time: float = 0.05

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

func set_weapon_behaviour_states():
	pass

func _ready():
	RunGlobal.WEAPON_PLAYER = self
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


func destroy():
	RunGlobal.PLAYER.restore(global_position)
	RunGlobal.WEAPON_PLAYER = null
	queue_free()


func disabled_collision():
	collision_shape_2d.disabled = true


func enable_collision():
	collision_shape_2d.disabled = false


func _on_weapon_have_to_destroy() -> void:
	destroy()
