extends DefaultEnemy

@export var bullets_per_volley: int = 5
var shots_in_current_volley: int = 0

@onready var shoot_reload_timer: Timer = $Timers/ShootReloadTimer
@export var shoot_reload_time: float = 0.3

@onready var volley_reload_timer: Timer = $Timers/VolleyReloadTimer
@export var volley_reload_time: float = 3.5

@export var bullet_scene = preload("res://scenes/enemies/technical/red_bullet.tscn")

@onready var shoot_points_parent: Node2D = $RotationalPart/ShootPoints
var shoot_points: Array = []

@export var SATISFACTORY_DIRECTION_DISTANCE: float = 700.0
@export var RAYCAST_ATTEMPTS: int = 10

@onready var collision_check_timer: Timer = $Timers/CollisionCheckTimer


func _ready() -> void:
	super._ready()
	shoot_reload_timer.wait_time = shoot_reload_time
	volley_reload_timer.wait_time = volley_reload_time
	volley_reload_timer.start()
	shoot_points = shoot_points_parent.get_children()
	animation_player.play("flying")


func calc_animation():
	if not is_dying:
		animation_player.play("flying")
		return
	animation_player.stop()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	var is_collided: bool = move_and_slide()
	if is_collided and collision_check_timer.time_left == 0:
		direction = Vector2.ZERO


func calc_move(delta: float) -> void:
	if not calc_velocity:
		return
	velocity = direction * SPEED


func choose_random_direction():
	var space_state = get_world_2d().direct_space_state
	var attempts = 0

	var best_direction: Vector2 = Vector2.ZERO
	var max_found_distance: float = 0.0
	
	while attempts < RAYCAST_ATTEMPTS:
		var random_angle = randf_range(0, PI * 2)
		var calc_direction = Vector2(cos(random_angle), sin(random_angle)).normalized()
		var ray_length = SATISFACTORY_DIRECTION_DISTANCE * 2

		var query = PhysicsRayQueryParameters2D.create($Collision.global_position, global_position + calc_direction * ray_length)
		query.collision_mask = 1 << 6  # 7th layer

		var result = space_state.intersect_ray(query)

		if result.is_empty():
			direction = calc_direction
			return
		else:
			var distance = global_position.distance_to(result.position)
			if distance >= SATISFACTORY_DIRECTION_DISTANCE:
				direction = calc_direction
				return
			elif distance > max_found_distance:
				max_found_distance = distance
				best_direction = calc_direction
		attempts += 1

	if best_direction != Vector2.ZERO:
		direction = best_direction
	else:
		direction = Vector2.ZERO


func shoot():
	for shoot_point in shoot_points:
		$Sounds/ShootAudioStreamPlayer2D.custom_play()
		var direction: Vector2 = (shoot_point.global_position - shoot_points_parent.global_position).normalized()
		shoot_point_shoot(shoot_point.global_position, direction)
		
	
func shoot_point_shoot(shoot_point_position: Vector2, shoot_direction: Vector2):
	player_position = get_player_position()
	var bullet_node = bullet_scene.instantiate()
	bullet_node.direction = shoot_direction.normalized()
	bullet_node.global_position = shoot_point_position
	ENEMY_ATACK_NODE.add_child(bullet_node)

func _on_shoot_reload_timer_timeout() -> void:
	if shots_in_current_volley == bullets_per_volley:
		volley_reload_timer.start()
		return
	shoot()
	shots_in_current_volley += 1
	shoot_reload_timer.start()


func _on_volley_reload_timer_timeout() -> void:
	shots_in_current_volley = 0
	choose_random_direction()
	collision_check_timer.start()
	_on_shoot_reload_timer_timeout()
