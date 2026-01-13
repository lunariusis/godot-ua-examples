class_name Idle extends StatePlayer


func enter(_msg: Dictionary={}) -> void:
	player.animation_play(player.ANIMATION_NAMES.animation_idle)
	player.velocity = Vector2.ZERO
	debug_label_update()

func inner_physics_process(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.change_to(player.PLAYER_STATES.JUMP)

	# Transition to WALK or RUN state if valid horizontal input is detected
	if (player.in_left or player.in_right) and not (player.in_left and player.in_right):
		state_machine.change_to(player.PLAYER_STATES.RUN if player.in_running else player.PLAYER_STATES.WALK)
	
	# Pass 'do_jump = true' to signal the JUMP state that the transition is due to an active jump input.
	if player.in_jumping:
		state_machine.change_to(player.PLAYER_STATES.JUMP, {do_jump = true})
