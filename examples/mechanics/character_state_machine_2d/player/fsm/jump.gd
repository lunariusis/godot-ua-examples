class_name Jump extends StatePlayer
"""
This state handles both jumping and falling.
A separate 'FALL' state is intentionally not implemented
to demonstrate message handling: the 'do_jump' message differentiates
an active jump (initial upward velocity) from a passive fall.
"""

var direction: float = 0

func enter(_msg: Dictionary={}) -> void:
	var input_direction: float = player.in_direction
	
	if input_direction == null:
		direction = 0
	else:
		direction = input_direction
		player.animation_change_direction(direction)

	if _msg.has("do_jump") and _msg.do_jump:
		debug_label_update()
		player.velocity.y = player.jump_speed
		player.animation_play(player.ANIMATION_NAMES.animation_jump)
	else :
		debug_label_update(player.ANIMATION_NAMES.animation_fall)
		player.animation_play(player.ANIMATION_NAMES.animation_fall)

func inner_physics_process(delta: float) -> void:
	player.velocity.x = player.player_speed * direction * delta
	player.move_and_slide()
	if player.is_on_floor():
		state_machine.change_to(player.PLAYER_STATES.IDLE)
