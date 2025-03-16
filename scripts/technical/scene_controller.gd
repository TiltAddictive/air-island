extends Node

const MAIN_MENU = "res://scenes/UI/main_menu.tscn"
const MAIN_LEVEL = "res://scenes/levels/main_level.tscn"

var current_scene: Node = null
@onready var scene_root: Node =  $"." # 👈 Сюда будем грузить сцены

func _ready():
	change_scene(MAIN_MENU)
	print("MAIN_MENU is: ", MAIN_MENU)
	print("MAIN_LEVEL is: ", MAIN_LEVEL)


#func change_scene(new_scene_path: String):
	#print("Current Scene: ", current_scene)
	#if current_scene:
		#print("Removing current scene: ", current_scene.name)
		#current_scene.queue_free()
	#print("Changing to new_scene: ", new_scene_path)
	#var new_scene = load(new_scene_path)
	#current_scene = new_scene.instantiate()
	#print("current_scene is now ", current_scene)
	#get_tree().root.add_child(current_scene)
	#print("Loaded new scene: ", current_scene.name)


func change_scene(new_scene_path: String):
	print("Current Scene: ", current_scene)
	if current_scene:
		print("Removing current scene: ", current_scene.name)
		current_scene.queue_free()
	print("Changing to new_scene: ", new_scene_path)
	var new_scene = load(new_scene_path)
	current_scene = new_scene.instantiate()
	print("current_scene is now ", current_scene)
	scene_root.add_child(current_scene)  # 👈 Добавляем ВНУТРЬ SceneRoot
	print("Loaded new scene: ", current_scene.name)


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
		else:
			print("Warning: Scene does not have 'closed' signal!")


func start_new_game():
	change_scene(MAIN_LEVEL)


func return_to_main_menu():
	change_scene(MAIN_MENU)


func quit_game():
	print("Quitting game...")
	get_tree().quit()
