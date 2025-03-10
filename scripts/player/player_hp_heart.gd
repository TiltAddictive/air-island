extends Control

@onready var heart_texture: TextureRect = $HeartTexture
var full_heart_path: String = "res://resourses/sprites/player/full-heart.png"
var empty_heart_path: String = "res://resourses/sprites/player/empty-heart.png"

func make_empty():
	heart_texture.texture = load(empty_heart_path)

func make_full():
	heart_texture.texture = load(full_heart_path)
