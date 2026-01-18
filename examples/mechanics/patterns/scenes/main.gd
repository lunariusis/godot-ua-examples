extends Control

@onready var state_pattern_button: Button = $VBoxContainer/StatePatternButton

func _ready() -> void:
	state_pattern_button.pressed.connect(_on_state_pattern_button_pressed)

func _on_state_pattern_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/patterns/state_machine/state_machine_example.tscn")
