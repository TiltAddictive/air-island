extends DefaultEnemy

enum STATES {TOO_CLOSE, SATISFACTORY_DISTANCE, ATTACK}
var current_state: STATES
@export var bomb_spawn_area_range: float = 70
@export var panic_area_radius: float = 150
@onready var panic_area_2d: Area2D = $PanicArea2D

var bombs_spawned: int = 0
@export var bomb_spawn_delay: float = 0.1
@export var bombs_to_spawn: int = 3

@export var change_random_direction_time: float = 2
@onready var change_random_direction_timer: Timer = $Timers/ChangeRandomDirectionTimer

@export var bomb_scene: PackedScene
@onready var bomb_spawn_timer: Timer = $Timers/BombSpawnTimer

var change_random_direction: bool = true


func _ready() -> void:
	super._ready()
	can_attack = false
	change_random_direction_timer.wait_time = change_random_direction_time
	bomb_spawn_timer.wait_time = bomb_spawn_delay
	attack_reload_timer.start()
	$PanicArea2D/CollisionShape2D.shape.radius = panic_area_radius


func _physics_process(delta: float) -> void:
	calc_state()
	super._physics_process(delta)
	move_and_slide()


func calc_animation():
	if current_state == STATES.ATTACK:
		return
	super.calc_animation()


func calc_state() -> void:
	if current_state == STATES.ATTACK:
		return
	player_position = get_player_position()
	if (global_position - player_position).length() < panic_area_radius:
		current_state = STATES.TOO_CLOSE
	else:
		current_state = STATES.SATISFACTORY_DISTANCE


func calc_move(delta: float):
	if not calc_velocity:
		return
	if current_state == STATES.ATTACK:
		return
	if current_state == STATES.TOO_CLOSE:
		direction = (global_position - player_position).normalized()
	if current_state == STATES.SATISFACTORY_DISTANCE and change_random_direction:
		change_random_direction = false
		change_random_direction_timer.start()
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	velocity = direction * SPEED


func calc_attack():
	if not can_attack:
		return
	can_attack = false
	current_state = STATES.ATTACK
	velocity = Vector2.ZERO
	animation_player.play("attack_spawning")


func start_spawning_bombs():
	bombs_spawned = 0
	_on_bomb_spawn_timer_timeout()


func spawn_bomb():
	var bomb_node: Node2D = bomb_scene.instantiate()
	bomb_node.global_position = RunAuxiliaryScript.get_random_area(player_position, bomb_spawn_area_range)
	ENEMY_ATACK_NODE.add_child(bomb_node)


func _on_change_random_direction_timer_timeout() -> void:
	change_random_direction = true


func _on_attack_reload_timer_timeout() -> void:
	can_attack = true


func _on_bomb_spawn_timer_timeout() -> void:
	if bombs_spawned >= bombs_to_spawn:
		current_state = STATES.SATISFACTORY_DISTANCE
		attack_reload_timer.start()
		bomb_spawn_timer.stop()
		bombs_spawned = 0
		return
	spawn_bomb()
	bombs_spawned += 1
	bomb_spawn_timer.start()
