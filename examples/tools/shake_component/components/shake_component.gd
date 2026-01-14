@tool
## A versatile component for adding interactive visual effects to any Node2D.
## It automatically creates and manages an Area2D to detect mouse interaction.
class_name ShakeComponent extends Node2D

# This component, when added to a Node2D, will automatically create an Area2D
# to detect mouse hovers and trigger a specified effect.

enum EffectType {
	SHAKE,
	SCALE_UP_DOWN,
	FLEE_RETURN,
	# Add other effects here as needed
}

@export var effect_type: EffectType = EffectType.SHAKE

## Optional. Assign a ShaderMaterial to enable the outline hover effect.
@export var outline_shader_material: ShaderMaterial = null:
	set(value):
		outline_shader_material = value
		# When in the editor, update the inspector to show/hide dynamic properties.
		if Engine.is_editor_hint() and is_inside_tree():
			notify_property_list_changed()

# Member variables for properties managed by _get_property_list
var outline_hover_enable: bool = false
var outline_hover_color: Color = Color.WHITE

@export_group("Triggers", "effect_")
@export var effect_on_enter: bool = true
@export var effect_on_exit: bool = false

@export_group("Shake Parameters", "shake_")
@export var shake_strength: float = 8.0 # Shake distance in pixels
@export var shake_rotation_strength: float = 1.5 # Shake angle in degrees
@export var shake_duration: float = 0.4  # Total duration of the shake
@export var shake_count: int = 8        # Number of 'jumps' within the duration

@export_group("Scale Effect Parameters", "scale_")
@export var scale_amount: float = 1.1 # How much to scale up (e.g., 1.2 for 120%)
@export var scale_duration: float = 0.2  # Total duration of the up-and-down animation

@export_group("Flee Effect Parameters", "flee_")
@export var flee_distance: float = 50.0 # How far to flee
@export var flee_duration: float = 0.4  # Total duration of the flee
@export var flee_lerp_speed: float = 5.0 # How fast to return


var _parent: Node2D
var _active_tween: Tween
var _area: Area2D
var _original_scale: Vector2
var _original_pos: Vector2
var _original_rot: float
var _flee_active: bool = false
var _original_outline_color: Color
var _original_parent_material: Material


const SHAKE_AREA_NAME = "ShakeArea"


## This is a special Godot function that runs in the editor.
## It allows dynamically adding properties to the Inspector based on other variables.
## Here, we use it to show outline-related properties only when a material is assigned.
func _get_property_list():
	var properties = []
	
	# The outline_shader_material is already exported, so we don't add it here.
	# We only add the properties that should appear dynamically.
	
	if outline_shader_material:
		var outline_group = {
			"name": "Outline Hover Parameters",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP,
			"hint_string": "outline_hover_"
		}
		properties.append(outline_group)
		
		properties.append({
			"name": "outline_hover_enable",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT
		})
		properties.append({
			"name": "outline_hover_color",
			"type": TYPE_COLOR,
			"usage": PROPERTY_USAGE_DEFAULT
		})

	return properties


func _enter_tree():
	_parent = get_parent()
	
	if not _parent or not _parent is Node2D:
		return

	_original_scale = _parent.scale
	_original_pos = _parent.position
	_original_rot = _parent.rotation

	# Since this is a @tool script, this code runs in the editor.
	# We set up the necessary child nodes (Area2D) for the component to be visible
	# and functional without running the game.
	if Engine.is_editor_hint():
		call_deferred("_setup_editor_nodes")
		set_meta("_edit_lock_", true)
	
	call_deferred("_connect_signals")


func _setup_editor_nodes():
	if not Engine.is_editor_hint():
		return
	if not has_node(SHAKE_AREA_NAME):
		_create_shake_area()


## In @tool mode, creates the Area2D and CollisionShape2D required for mouse detection.
func _create_shake_area():
	if not Engine.is_editor_hint():
		return
	var area = Area2D.new()
	area.name = SHAKE_AREA_NAME
	_add_editor_child(self, area)

	var collision_shape = CollisionShape2D.new()
	_add_editor_child(area, collision_shape)
	
	var shape = RectangleShape2D.new()
	
	# Check if the parent has a get_rect method, which is safer than checking the type.
	if _parent.has_method("get_rect"):
		var rect = _parent.get_rect()
		shape.size = rect.size
		area.position = rect.position + (rect.size / 2.0)
		collision_shape.position = Vector2.ZERO
	else:
		# For nodes without a size (like pure Node2D), use a default 100x100 shape.
		shape.size = Vector2(100, 100)
		area.position = Vector2.ZERO
		collision_shape.position = Vector2.ZERO

	collision_shape.shape = shape

## In @tool mode, adds a child node and sets its owner so it's saved with the scene.
func _add_editor_child(parent_node: Node, child_node: Node, set_lock: bool = true):
	if not Engine.is_editor_hint():
		return
	parent_node.add_child(child_node)
	child_node.owner = get_tree().edited_scene_root
	if set_lock:
		child_node.set_meta("_edit_lock_", true)


func _prepare_tween() -> Tween:
	if not is_instance_id_valid(_parent.get_instance_id()):
		return null
	if _active_tween and _active_tween.is_valid():
		_active_tween.kill()
	_active_tween = get_tree().create_tween()
	return _active_tween


func _process(delta):
	if not is_instance_id_valid(_parent.get_instance_id()):
		set_process(false)
		return

	var target_pos: Vector2
	
	if _flee_active:
		var mouse_pos = get_global_mouse_position()
		var parent_pos = _parent.global_position
		var direction = (parent_pos - mouse_pos).normalized()
		
		if direction == Vector2.ZERO:
			direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
		
		target_pos = _original_pos + direction * flee_distance
	else:
		target_pos = _original_pos

	_parent.position = _parent.position.lerp(target_pos, flee_lerp_speed * delta)
	
	if not _flee_active and _parent.position.distance_to(_original_pos) < 0.1:
		set_process(false)


func _connect_signals():
	_area = get_node_or_null(SHAKE_AREA_NAME)
	if _area and _area is Area2D:
		if not _area.mouse_entered.is_connected(_on_mouse_entered):
			_area.mouse_entered.connect(_on_mouse_entered)
		if not _area.mouse_exited.is_connected(_on_mouse_exited):
			_area.mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered():
	if not effect_on_enter:
		return

	match effect_type:
		EffectType.SHAKE:
			_start_shake_effect()
		EffectType.SCALE_UP_DOWN:
			_animate_scale(_original_scale * scale_amount)
		EffectType.FLEE_RETURN:
			_flee_active = true
			set_process(true)
	
	_handle_outline_hover_effect(true)


func _on_mouse_exited():
	match effect_type:
		EffectType.SCALE_UP_DOWN:
			_animate_scale(_original_scale)
		EffectType.FLEE_RETURN:
			_flee_active = false
	
	if effect_on_exit and effect_type == EffectType.SHAKE:
		_start_shake_effect()
	
	_handle_outline_hover_effect(false)


func _handle_outline_hover_effect(is_entered: bool):
	if not outline_hover_enable or not _parent is CanvasItem:
		return

	var shader_material_ref = _get_outline_shader_material()
	if not shader_material_ref:
		return

	# In Godot 4, you check for a parameter's existence by trying to get it and checking for null.
	if shader_material_ref.get_shader_parameter("outline_color") == null:
		return

	if is_entered:
		# Save the original material before applying the new one
		_original_parent_material = _parent.material
		_parent.material = shader_material_ref
		
		# Now, set the hover color
		_original_outline_color = shader_material_ref.get_shader_parameter("outline_color")
		shader_material_ref.set_shader_parameter("outline_color", outline_hover_color)
	else:
		# Restore the original material only if the component set it
		if _parent.material == shader_material_ref:
			_parent.material = _original_parent_material
		
		# Reset the color on the (now detached) shader material for the next hover
		shader_material_ref.set_shader_parameter("outline_color", _original_outline_color)


func _get_outline_shader_material() -> ShaderMaterial:
	if outline_shader_material:
		return outline_shader_material
	return null


func _start_shake_effect():
	var tween = _prepare_tween()
	if not tween:
		return
	
	var time_per_shake = shake_duration / float(shake_count)
	
	for i in range(shake_count):
		var rand_pos_offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * shake_strength
		var rand_rot_offset = deg_to_rad(randf_range(-shake_rotation_strength, shake_rotation_strength))
		
		tween.tween_property(_parent, "position", _original_pos + rand_pos_offset, time_per_shake)
		tween.parallel().tween_property(_parent, "rotation", _original_rot + rand_rot_offset, time_per_shake)
	
	tween.tween_property(_parent, "position", _original_pos, time_per_shake)
	tween.parallel().tween_property(_parent, "rotation", _original_rot, time_per_shake)


func _animate_scale(p_target_scale: Vector2):
	var tween = _prepare_tween()
	if not tween:
		return
	tween.set_ease(Tween.EASE_OUT_IN)
	# The scale animation is split in two, so we use half the duration.
	tween.tween_property(_parent, "scale", p_target_scale, scale_duration / 2.0)
