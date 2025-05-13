extends Node2D
class_name Lazer

signal lazer_ends

@onready var line: Line2D = $Line2D
@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var preparation_timer: Timer = $Timers/PreparationTimer
@onready var attack_timer: Timer = $Timers/AttackTimer
@onready var ray_cast_2d: RayCast2D = $RayCast2D

@export var laser_damage: float = 5.0  # Урон в секунду
@export var attack_preparation_time: float = 1.0  # Время подготовки
@export var attack_duration: float = 2.0  # Длительность атаки
@export var laser_range: float = 3000.0  # Дальность луча
@export var rejection_force: float = 200.0  # Сила отталкивания
var player: Node2D = null  # Ссылка на игрока
var is_preparing: bool = false
var is_attacking: bool = false
var current_laser_length: float = 0.0

func _ready() -> void:
	preparation_timer.wait_time = attack_preparation_time
	attack_timer.wait_time = attack_duration

	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2(laser_range, 0))
	line.visible = false
	area.monitoring = false

func start_laser() -> void:
	player = RunGlobal.get_closest_player(global_position)
	is_preparing = true
	line.visible = true
	line.modulate = Color(1, 1, 1, 0.5)
	update_laser_direction()
	preparation_timer.start()

func _physics_process(_delta: float) -> void:
	if is_preparing or is_attacking:
		update_laser_direction()
	if is_attacking:
		deal_damage()

func update_laser_direction() -> void:
	if not player:
		return
	var cast_point = to_local(player.global_position)
	ray_cast_2d.target_position = cast_point
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		cast_point = to_local(ray_cast_2d.get_collision_point())
	line.points[1] = cast_point

	var lazer_length: float = min(laser_range, cast_point.length())
	var shape = RectangleShape2D.new()
	shape.size = Vector2(lazer_length, 10)
	collision_shape.shape = shape
	
	var end_point = cast_point.normalized() * lazer_length
	collision_shape.position = end_point / 2
	
	var direction = cast_point.normalized()
	collision_shape.rotation = direction.angle()


func deal_damage() -> void:
	return
	for body in area.get_overlapping_bodies():
		if body.has_method("get_hit"):
			var impulse_vector = (body.global_position - global_position).normalized() * rejection_force
			body.get_hit(laser_damage, impulse_vector)

func _on_preparation_timer_timeout() -> void:
	is_preparing = false
	is_attacking = true
	line.modulate = Color(1, 0, 0, 1)
	area.monitoring = true
	attack_timer.start()

func _on_attack_timer_timeout() -> void:
	is_attacking = false
	line.visible = false
	area.monitoring = false
	lazer_ends.emit()
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	return
	if is_attacking and body.has_method("get_hit"):
		var player_local_pos = to_local(body.global_position)
		var player_distance = player_local_pos.x
		if player_distance <= current_laser_length:
			var impulse_vector = (body.global_position - global_position).normalized() * rejection_force
			body.get_hit(laser_damage, impulse_vector)

#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if is_attacking and body.has_method("get_hit"):
		#var impulse_vector = (body.global_position - global_position).normalized() * rejection_force
		#body.get_hit(laser_damage, impulse_vector)
