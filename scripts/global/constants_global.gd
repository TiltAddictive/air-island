extends Node

var VELOCITY_EPS: float = 0.05

func _ready() -> void:
	TranslationServer.set_locale("en")


func clear_node(node: Node):
	for child in node.get_children():
		child.queue_free()
