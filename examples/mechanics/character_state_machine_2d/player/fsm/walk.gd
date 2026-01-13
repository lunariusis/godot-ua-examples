class_name Walk extends StatePlayer

var animation_name = ""

func enter(_msg: Dictionary={}) -> void:
	_setup()
	player.animation_play(animation_name)
	debug_label_update()

func inner_physics_process(delta: float) -> void:
	var direction = player.in_direction
	if direction == null:
		direction = 0

	if direction != 0:
		player.animation_change_direction(direction)
		player.velocity.x = lerp(player.velocity.x, player.player_speed * direction * delta, 0.5)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, player.player_speed/10.0 * delta)
	
	player.move_and_slide()
	
	if player.velocity.x == 0 and direction == 0:
		state_machine.change_to(player.PLAYER_STATES.IDLE)
		
	if not player.is_on_floor():
		state_machine.change_to(player.PLAYER_STATES.JUMP)

	if player.in_jumping:
		state_machine.change_to(player.PLAYER_STATES.JUMP, {do_jump = true})
	
	_swap_wolking_style()

func _setup() -> void:
	animation_name = player.ANIMATION_NAMES.animation_walk

func _swap_wolking_style() -> void:
	if player.in_running:
		state_machine.change_to(player.PLAYER_STATES.RUN)
