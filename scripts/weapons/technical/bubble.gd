extends DefaultWeapon

@export var with_player: bool = true
@onready var live_timer: Timer = $Timers/LiveTimer
@export var live_time: float = 2
@onready var animation_player: AnimationPlayer = $RotationalPart/Sprite2D/AnimationPlayer
@export var number_of_clones: int = 3
@onready var damage_area: Area2D = $RotationalPart/DamageArea

@onready var attack_reload_timer: Timer = $Timers/AttackReloadTimer
@export var attack_reload_time: float = 0.6

func _ready() -> void:
	super._ready()
	$RotationalPart/Sprite2D.modulate = "#ffffff"
	if with_player:
		$RotationalPart/Sprite2D.modulate = "#e4a54c"
	spawn_clones()
	velocity = direction * SPEED
	animation_player.play("idle")
	live_timer.start(live_time)
	attack_reload_timer.wait_time = attack_reload_time
	attack()


func _physics_process(delta: float) -> void:
	move_and_slide()


func spawn_clones():
	if not with_player:
		return
	for i in range(1, number_of_clones + 1):
		var clone = self.duplicate()
		var angle = (TAU / number_of_clones) * i
		var clone_direction = Vector2(cos(angle), sin(angle)).normalized()
		clone.with_player = false
		clone.global_position = global_position
		clone.direction = clone_direction
		get_parent().add_child(clone)


func get_hit(damage: float, impulse: Vector2 = Vector2.ZERO) -> void:
	if not with_player:
		return
	super.get_hit(damage, impulse)


func start_destroying():
	if with_player:
		destroy()
	else:
		queue_free()


func _on_live_timer_timeout() -> void:
	animation_player.play("pop")


func attack():
	for body in damage_area.get_overlapping_bodies():
		if body.has_method("get_hit"):
			body.get_hit(DAMAGE)
	attack_reload_timer.start()


func _on_attack_reload_timer_timeout() -> void:
	attack()
