class_name StateMachine extends RefCounted

@warning_ignore("unused_signal")
signal state_updated(data: Dictionary)

var states: Dictionary = {}
var current_state: State = null

func add_state(state_name: String, state_instance: State) -> void:
	states[state_name] = state_instance
	state_instance.state_machine = self

func set_initial_state(state_name: String) -> void:
	if not states.has(state_name):
		return

	current_state = states[state_name]
	current_state.enter()

func change_state(new_state_name: String) -> void:
	if not states.has(new_state_name) or current_state == states[new_state_name]:
		return

	if current_state:
		current_state.exit()

	current_state = states[new_state_name]
	current_state.enter()

func call_on_state(method: String, args: Array = []) -> void:
	if current_state and current_state.has_method(method):
		current_state.callv(method, args)
