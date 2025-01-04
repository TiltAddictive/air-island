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
	var direction = to_local(navigation_agent.get_next_path_position())
	if direction.length() >= 2:
		velocity = direction.normalized() * SPEED
	move_and_slide()


func set_target():
	navigation_agent.target_position = get_player_position()
	search_target_timer.start()


func _on_search_target_timer_timeout() -> void:
	set_target()
