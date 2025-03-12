extends Walker


@export var bullet_scene = preload("res://scenes/enemies/technical/red_bullet.tscn")
@export var MIN_SHOOT_RELOAD_TIME: float = 2
@export var MAX_SHOOT_RELOAD_TIME: float = 4

func _ready() -> void:
	super._ready()
	start_reloading()

func shoot():
	player_position = get_player_position()
	var bullet_node = bullet_scene.instantiate()
	bullet_node.direction = (player_position - global_position).normalized()
	bullet_node.global_position = $RotationalPart/ShootingNode.global_position
	ENEMY_ATACK_NODE.add_child(bullet_node)

func get_hit(damage: float, impulse: Vector2 = Vector2.ZERO, impulse_impact_time: float = 0) -> void:
	start_reloading()
	super.get_hit(damage, impulse, impulse_impact_time)

func get_reload_time():
	return randf_range(MIN_SHOOT_RELOAD_TIME, MAX_SHOOT_RELOAD_TIME)


func start_reloading():
	$Timers/ShootReloadTimer.start(get_reload_time())

func _on_shoot_reload_timer_timeout() -> void:
	shoot()
	start_reloading()
