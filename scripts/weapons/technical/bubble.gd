extends DefaultWeapon

@export var with_player: bool = true
@onready var live_timer: Timer = $Timers/LiveTimer
@export var live_time: float = 2
@onready var animation_player: AnimationPlayer = $RotationalPart/Sprite2D/AnimationPlayer
@export var number_of_clones: int = 3

func _ready() -> void:
	super._ready()
	$RotationalPart/Sprite2D.modulate = "#ffffff"
	if with_player:
		$RotationalPart/Sprite2D.modulate = "#e4a54c"
	spawn_clones()
	velocity = direction * SPEED
	animation_player.play("idle")
	live_timer.start(live_time)


func _physics_process(delta: float) -> void:
	move_and_slide()


func spawn_clones():
	if not with_player:
		return
	for i in range(number_of_clones):
		var clone = self.duplicate()
		var angle = (TAU / number_of_clones) * i
		var direction = Vector2(cos(angle), sin(angle)).normalized()
		clone.with_player = false
		clone.global_position = global_position
		clone.direction = direction
		get_parent().add_child(clone)


func start_destroying():
	if with_player:
		destroy()
	else:
		queue_free()


func _on_live_timer_timeout() -> void:
	animation_player.play("pop")


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.has_method("get_hit"):
		body.get_hit(DAMAGE)
