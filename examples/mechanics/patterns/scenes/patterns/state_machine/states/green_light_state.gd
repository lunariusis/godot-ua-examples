class_name GreenLightState extends State

func enter() -> void:
	state_machine.state_updated.emit({
		"label": "Current State: GREEN",
		"lights": [false, false, true, false]
	})

func handle_action() -> void:
	state_machine.change_state("green_arrow")
