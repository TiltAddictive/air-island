extends Node

const MAIN_MENU = "res://scenes/UI/main_menu.tscn"
const MAIN_LEVEL = "res://scenes/levels/main_level.tscn"

var current_scene: Node = null
@onready var scene_root: Node =  $"."

func _ready():
	change_scene(MAIN_MENU)


func change_scene(new_scene_path: String):

	if current_scene:
		current_scene.queue_free()
	var new_scene = load(new_scene_path)
	current_scene = new_scene.instantiate()
	scene_root.add_child(current_scene)


func open_above_the_current_scene(
		scene_path: String,
		hide_node: Node = null,
		parent_node: Node = null,
		caller_node: Node = null,
		new_scene_closed_func: String = "",
):
	var scene: PackedScene = load(scene_path)
	var node = scene.instantiate()
	if hide_node != null:
		node.called_node = hide_node
	if parent_node != null:
		parent_node.add_child(node)
	else:
		scene_root.add_child(node)
	if caller_node != null and new_scene_closed_func != "":
		if node.has_signal("closed"):
			node.connect("closed", Callable(caller_node, new_scene_closed_func))


func start_new_game():
	change_scene(MAIN_LEVEL)


func return_to_main_menu():
	change_scene(MAIN_MENU)


func quit_game():
	print("Quitting game...")
	get_tree().quit()
