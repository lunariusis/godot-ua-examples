extends Node2D


const game = preload("res://scenes/level.tscn")

func _ready():
	call_deferred("add_scene", game)

func add_scene(scene):
	get_tree().change_scene_to_packed(scene)
