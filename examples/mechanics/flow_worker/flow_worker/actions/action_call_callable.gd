class_name ActionCallCallable extends FlowAction


var _callable: Callable

func _init(callable_to_call: Callable) -> void:
	_callable = callable_to_call

func execute() -> Signal:
	var name_class: String = get_script().get_global_name()
	print("Execute %s" % name_class)
	if _callable.is_valid():
		_callable.call()
	else:
		printerr("%s: Provided callable is not valid!" % name_class)
	return next_action
