class_name Run extends Walk


func _setup() -> void:
	animation_name = player.ANIMATION_NAMES.animation_run

func _swap_wolking_style() -> void:
	if !player.in_running:
		state_machine.change_to(player.PLAYER_STATES.WALK)
