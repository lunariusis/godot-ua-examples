class_name StateMachine extends Node


@export var start_state: NodePath

@onready var state: State = get_node(start_state)

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.state_machine = self
		else:
			push_warning("FSM: Non-State node '" + child.name + "' is a child of StateMachine. It will be ignored.")

	if state == null:
		_shutdown("FSM ERROR: Initial state is null. Please set 'start_state' in the inspector.")
		return

	if not (state is State):
		_shutdown("FSM ERROR: Initial state '" + state.name + "' is not a valid State type.")
		return

	state.enter()

func _shutdown(error_message: String) -> void:
	push_error(error_message)
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)

func _unhandled_input(event) -> void:
	state.inner_unhandled_input(event)

func _process(delta) -> void:
	state.inner_process(delta)

func _physics_process(delta) -> void:
	state.inner_physics_process(delta)

func change_to(target_state: Player.PLAYER_STATES, msg: Dictionary={}) -> void:
	var name_state = _get_state_name(target_state)
	if not has_node(name_state):
		push_error("Trying get wrong state: " + name_state)
		return
	state.exit()
	state = get_node(name_state) as State
	state.enter(msg)
	if state.player.debug:
		print("Current state: " + state.name)

func _get_state_name(target_state: Player.PLAYER_STATES) -> String:
	return state.player.PLAYER_STATES.keys()[target_state]
	
