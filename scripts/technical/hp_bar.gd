extends Control
class_name HPBar

@onready var progress: ProgressBar = $ProgressBar
@export var object: DefaultEnemy


func _ready() -> void:
	set_object_as_parent_node()
	progress.max_value = object.MAX_HP
	progress.value = object.hp


func _process(delta: float) -> void:
	if object == null:
		return
	if object.hp == object.MAX_HP and visible:
		visible = false
	if object.hp != object.MAX_HP and not visible:
		visible = true
	progress.value = object.hp


func set_object_as_parent_node():
	if object == null:
		object = get_parent()
