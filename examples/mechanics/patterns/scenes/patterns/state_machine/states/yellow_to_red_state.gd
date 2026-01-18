class_name YellowToRedState extends BaseYellowState

func handle_action() -> void:
	state_machine.change_state("red")
