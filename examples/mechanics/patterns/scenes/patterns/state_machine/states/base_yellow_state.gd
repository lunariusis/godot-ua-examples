class_name BaseYellowState extends State

func enter() -> void:
	state_machine.state_updated.emit({
		"label": "Current State: YELLOW",
		"lights": [false, true, false, false]
	})
