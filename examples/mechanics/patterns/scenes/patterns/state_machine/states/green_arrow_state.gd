class_name GreenArrowState extends State

func enter() -> void:
	state_machine.state_updated.emit({
		"label": "Current State: GREEN ARROW",
		"lights": [false, false, true, true]
	})

func exit() -> void:
	pass

func handle_action() -> void:
	state_machine.change_state("yellow_to_red")
