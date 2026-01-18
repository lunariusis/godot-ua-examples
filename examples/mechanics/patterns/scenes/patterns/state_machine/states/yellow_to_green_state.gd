class_name YellowToGreenState extends BaseYellowState

func handle_action() -> void:
	state_machine.change_state("green")
