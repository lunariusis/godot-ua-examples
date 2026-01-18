extends Control

@onready var traffic_light_view: Control = %TrafficLight
@onready var current_state_label: Label = %CurrentStateLabel
@onready var transition_button: Button = %TransitionButton

var fsm: StateMachine

func _ready() -> void:
	fsm = StateMachine.new()

	fsm.add_state("red", RedLightState.new())
	fsm.add_state("yellow_to_red", YellowToRedState.new())
	fsm.add_state("yellow_to_green", YellowToGreenState.new())
	fsm.add_state("green", GreenLightState.new())
	fsm.add_state("green_arrow", GreenArrowState.new())
	
	transition_button.pressed.connect(_on_transition_button_pressed)
	fsm.view_updated.connect(_on_view_updated)
	
	fsm.set_initial_state("red")

func _on_transition_button_pressed() -> void:
	fsm.call_on_state("handle_action")

func _on_view_updated(data: Dictionary) -> void:
	current_state_label.text = data.get("label", "UNKNOWN STATE")
	var lights: Array = data.get("lights", [false, false, false, false])
	traffic_light_view.update_lights(lights[0], lights[1], lights[2], lights[3])

func _on_return_to_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
