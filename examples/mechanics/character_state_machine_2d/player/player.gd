class_name Player extends CharacterBody2D


@export_group("debug")
@export var debug:bool = true
@export_group("respawn")
@export var respawn: Marker2D = null
@export_group("camera")
@export var camera_limit_left: Marker2D = null
@export var camera_limit_right: Marker2D = null
@export_group("areas")
@export var slow_areas: Array[Area2D]
@export var kill_areas: Array[Area2D]

enum PLAYER_STATES {NONE, IDLE, WALK, RUN, JUMP}

const ANIMATION_NAMES = {
	animation_jump = "jump",
	animation_fall = "fall",
	animation_idle = "idle",
	animation_walk = "walk",
	animation_run = "run"
	}

const PLAYER_CONFIG = {
	cf_run_speed = 10000.0, 
	cf_walk_speed = 2500.0, 
	cf_jump_run_speed = -360,
	cf_jump_walk_speed = -300.0,
	cf_slowmo_start_gravity = 300.0,
	cf_slowmo_end_gravity = 1200.0,
	cf_gravity = 1200.0,
	cf_slowmo_start_velocity_x = 0.0,
	cf_slowmo_start_velocity_y = 0.0,
	cf_slowmo_end_velocity_x = 0.0,
	cf_slowmo_end_velocity_y = 400.0,
	cf_critical_velocity_y = 2000.0,
	cf_camera_offset_delta = 0.04,
	cf_stop_speed = 0.0
	}

var in_right: bool
var in_left: bool
var in_jumping: bool
var in_direction: float
var in_shift: bool
var in_running: bool

var gravity: float = PLAYER_CONFIG.cf_gravity
var drop_player_speed = false

var player_speed : float : 
	get() :
		if drop_player_speed :
			return PLAYER_CONFIG.cf_stop_speed
		else :
			return float(PLAYER_CONFIG.cf_run_speed) if in_running else float(PLAYER_CONFIG.cf_walk_speed)

var jump_speed : float :
	get() : 
		return float(PLAYER_CONFIG.cf_jump_run_speed) if in_running else float(PLAYER_CONFIG.cf_jump_walk_speed)

func _ready() -> void:
	_setup_position()
	_setup_camera()
	_setup_areas()

func _setup_position() -> void:
	position = respawn.position

func _setup_camera() -> void:
	%Camera.make_current()
	%Camera.limit_left = camera_limit_left.position.x
	%Camera.limit_right = camera_limit_right.position.x
	%Camera.limit_top = camera_limit_left.position.y
	%Camera.limit_bottom = camera_limit_right.position.y

func _setup_areas() -> void:
	for area in kill_areas:
		area.body_entered.connect(_kill_area_entered.bind())
	for area in slow_areas:
		area.body_entered.connect(_slowmo_area_entered.bind())
		area.body_exited.connect(_slowmo_area_exited.bind())

func _kill_area_entered(_body) -> void:
	_respawn(_body)

func _slowmo_area_entered(_body) -> void:
	_slowmo_entered(_body)

func _slowmo_area_exited(_body) -> void:
	_slowmo_exited(_body)

func animation_play(animation_name: String) -> void:
	%Animation.play(animation_name)

func animation_change_direction(direction: float) -> void:
	if direction == 0:
		return
	%Animation.scale = Vector2(direction, 1)

func _physics_process(delta) -> void:
	if in_direction:
		%Camera.drag_horizontal_offset = lerp(%Camera.drag_horizontal_offset, in_direction, PLAYER_CONFIG.cf_camera_offset_delta)
	if velocity.y > PLAYER_CONFIG.cf_critical_velocity_y:
		velocity.y = 0
	velocity.y += gravity * delta

func _respawn(body) -> void:
	if not _it_is_me(body) : return
	_setup_position()
	drop_player_speed = false
	gravity = PLAYER_CONFIG.cf_gravity
	%StateMachine.change_to(Player.PLAYER_STATES.JUMP)

func _slowmo_entered(body) -> void:
	if not _it_is_me(body) : return
	drop_player_speed = true
	_slowmo_update(
		float(PLAYER_CONFIG.cf_slowmo_start_velocity_x),
		float(PLAYER_CONFIG.cf_slowmo_start_velocity_y),
		float(PLAYER_CONFIG.cf_slowmo_start_gravity)
	)

func _slowmo_exited(body) -> void:
	if not _it_is_me(body) : return
	_slowmo_update(
		float(PLAYER_CONFIG.cf_slowmo_end_velocity_x),
		float(PLAYER_CONFIG.cf_slowmo_end_velocity_y),
		float(PLAYER_CONFIG.cf_slowmo_end_gravity)
	)

func _slowmo_update(velocity_x: float, velocity_y: float, gravity_value: float) -> void:
	velocity.x = velocity_x
	velocity.y = velocity_y
	gravity = gravity_value

func _it_is_me(body) -> bool:
	return body == self

func _unhandled_input(_event) -> void:
	_key_scan()

func _key_scan():
	in_direction = Input.get_axis("to_left", "to_right")
	in_right = Input.is_action_pressed('to_right')
	in_left = Input.is_action_pressed('to_left')
	in_jumping = Input.is_action_just_pressed('to_jump')
	in_shift = Input.is_action_pressed("to_shift")
	in_running = !Input.is_action_pressed("to_shift")
