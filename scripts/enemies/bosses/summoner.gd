extends ExploziveWizard

@onready var particles_animation_player: AnimationPlayer = $RotationalPart/Particles/AnimationPlayer

@export var MIN_ENEMIES_IN_WAVE_AMOUNT: int = 4
@export var MAX_ENEMIES_IN_WAVE_AMOUNT: int = 6
@export var enemies_to_spawn: Array[PackedScene] = [	
	preload("res://scenes/enemies/tier1/navigation_enemy.tscn"),
	preload("res://scenes/enemies/tier1/the_eye_of_cthulhu.tscn"),
	preload("res://scenes/enemies/tier2/explosive_wizard.tscn"),
	preload("res://scenes/enemies/tier2/walker_shooter.tscn"),
	preload("res://scenes/enemies/tier2/jumper.tscn"),
]
@export var MIN_AVAILABLE_DISTANCE_TO_PLAYER: float = 150
@export var ENEMIES_LIMIT_FOR_SUMMON: int = 10
var ENEMY_NODE: Node2D

func _ready() -> void:
	super._ready()
	ENEMY_NODE = get_parent()

func calc_attack():
	if not can_attack or not should_spawn_enemies():
		return
	can_attack = false
	current_state = STATES.ATTACK
	velocity = Vector2.ZERO
	animation_player.play("attack_spawning")
	$RotationalPart/Particles.visible = true
	particles_animation_player.play("particle")


func spawn_enemies():
	particles_animation_player.stop()
	$RotationalPart/Particles.visible = false
	current_state = STATES.SATISFACTORY_DISTANCE
	attack_reload_timer.start()
	summon_enemies()


func should_spawn_enemies() -> bool:
	if ENEMY_NODE.get_child_count() >= ENEMIES_LIMIT_FOR_SUMMON:
		return false
	return true


func switch_rotational_scale():
	if sign(velocity.x) > 0:
		rotational_part.scale.x = -1
	elif sign(velocity.x) < 0:
		rotational_part.scale.x = 1


func summon_enemies():
	var enemies_amount: int = randi_range(MIN_ENEMIES_IN_WAVE_AMOUNT, MAX_ENEMIES_IN_WAVE_AMOUNT)
	for enemy_number in range(enemies_amount):
		if not should_spawn_enemies():
			continue
		var candidate_position: Vector2 = ZONE_SPAWNER.choose_item_position(self)
		if candidate_position == Vector2.INF:
			continue
		var enemy_scene: PackedScene = enemies_to_spawn.pick_random()
		var enemy_node = enemy_scene.instantiate()
		enemy_node.global_position = candidate_position
		enemy_node.ENEMY_ATACK_NODE = ENEMY_ATACK_NODE
		ENEMY_NODE.add_child(enemy_node)


func is_position_valid(candidate_position: Vector2) -> bool:
	if (candidate_position - RunGlobal.get_closest_player(candidate_position).global_position).length() > MIN_AVAILABLE_DISTANCE_TO_PLAYER:
		return true
	return false
