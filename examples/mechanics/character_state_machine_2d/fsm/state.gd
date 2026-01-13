class_name State extends Node

var state_machine : StateMachine = null

var player: Player

func _ready() -> void:
	pass

func inner_unhandled_input(_event: InputEvent) -> void:
	pass

func inner_process(_delta: float) -> void:
	pass

func inner_physics_process(_delta: float) -> void:
	pass

func enter(_msg: Dictionary={}) -> void:
	pass

func exit() -> void:
	pass
