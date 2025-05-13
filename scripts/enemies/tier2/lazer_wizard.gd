extends ExploziveWizard
class_name LaserWizard

@export var laser_scene: PackedScene  # Сцена лазера
@export var laser_damage: float = 5.0  # Урон в секунду
@export var attack_preparation_time: float = 1.0  # Время подготовки лазера
@export var attack_duration: float = 2.0  # Длительность активной фазы лазера
@export var laser_range: float = 3000.0  # Дальность луча
var laser: Node2D = null

func _ready() -> void:
	super._ready()
	bomb_spawn_timer.stop()
	bombs_spawned = 0
	can_attack = true

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func calc_attack() -> void:
	if not can_attack:
		return
	can_attack = false
	current_state = STATES.ATTACK
	velocity = Vector2.ZERO
	animation_player.play("attack_initiation")

func spawn_laser() -> void:
	laser = laser_scene.instantiate()
	laser.global_position = $RotationalPart/LazerStartPoint.global_position
	laser.laser_damage = laser_damage
	laser.attack_preparation_time = attack_preparation_time
	laser.attack_duration = attack_duration
	laser.laser_range = laser_range
	laser.rejection_force = REJECTION_FORCE_VALUE
	ENEMY_ATACK_NODE.add_child(laser)
	laser.start_laser()
	laser.connect("lazer_ends", lazer_ends)

func lazer_ends():
	current_state = STATES.SATISFACTORY_DISTANCE
	animation_player.stop()
	attack_reload_timer.start()
