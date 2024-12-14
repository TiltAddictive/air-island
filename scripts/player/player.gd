extends CharacterBody2D

# Move
var direction: Vector2 = Vector2.ZERO
var look_at_direction: Vector2 = Vector2.RIGHT
@export var SPEED: float = 300

# Attack
@export var WEAPON_NODE: Node2D = null

var can_attack: bool = true
var is_evaporated: bool = false
var can_get_damage: bool = true

func _ready() -> void:
	RunGlobal.PLAYER = self


func _physics_process(delta: float) -> void:
	get_input()
	calc_attack()
	velocity = direction * SPEED
	move_and_slide()


func get_input():
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	look_at_direction = direction if direction != Vector2.ZERO else look_at_direction


func calc_attack():
	if Input.is_action_just_pressed("attack") and can_attack and WEAPON_NODE:
		launch_weapon()


func launch_weapon():
	var weapon_node = RunGlobal.current_weapon.instantiate()
	weapon_node.global_position = global_position
	weapon_node.direction = look_at_direction
	WEAPON_NODE.add_child(weapon_node)
	start_evaporating()


func start_evaporating():
	if is_evaporated:
		return
	is_evaporated = true
	can_get_damage = false
	can_attack = false
	
	set_physics_process(false)  # Отключаем физическую обработку (перемещения и коллизии)
	visible = false


func restore(spawn_position: Vector2, damage: float = 0):
	if not is_evaporated:
		return
	#velocity = restore_direction.normalized() * impulse
	#velocity.x = abs(velocity.x) if is_moving_right else -abs(velocity.x)
	global_position = spawn_position
	is_evaporated = false
	visible = true
	can_attack = true
	set_physics_process(true)
