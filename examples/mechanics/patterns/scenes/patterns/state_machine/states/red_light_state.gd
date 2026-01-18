class_name RedLightState extends State

func enter() -> void:
	state_machine.view_updated.emit({
		"label": "Current State: RED",
		"lights": [true, false, false, false]
	})
	
func handle_action() -> void:
	state_machine.change_state("yellow_to_green")
