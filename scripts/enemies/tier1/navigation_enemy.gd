extends DefaultEnemy

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

# Timer
@export var search_target_time: float = 0.5
@onready var search_target_timer: Timer = $Timers/SearchTargetTimer


func _ready() -> void:
	super._ready()
	search_target_timer.wait_time = search_target_time
	set_target()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	move_and_slide()


func calc_move(_delta: float) -> void:
	if not calc_velocity:
		return
	var intended_velocity = to_local(navigation_agent.get_next_path_position()).normalized() * SPEED
	navigation_agent.velocity = intended_velocity
	return


func death() -> void:
	navigation_agent.avoidance_layers = 0
	super.death()


func set_target():
	navigation_agent.target_position = get_player_position()
	search_target_timer.start()


func _on_search_target_timer_timeout() -> void:
	set_target()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if not calc_velocity:
		return
	velocity = safe_velocity.normalized() * SPEED
