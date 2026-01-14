class_name ActionPause extends FlowAction


var _duration: float = 0.0

func _init(p_duration: float = 0.0) -> void:
	_duration = p_duration

func execute() -> Signal:
	print("Execute %s" % get_script().get_global_name())
	var timer = get_parent().get_tree().create_timer(_duration)
	return timer.timeout
