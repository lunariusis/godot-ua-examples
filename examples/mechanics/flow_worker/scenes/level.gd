extends Node2D


@onready var _flow_worker: FlowWorker = FlowWorker.new()

func _ready() -> void:
	add_child(_flow_worker)
	var example: int = 1
	var actions: Array[FlowAction] = [
				ActionCallCallable.new(_callable_test),
				ActionPause.new(1),
				ActionCallCallable.new(_callable_test)
			]
	match example:
		1:
			_flow_worker.add_action(actions[0])
			_flow_worker.add_action(actions[1])
			_flow_worker.add_action(actions[2])
			_flow_worker.start_processing()
		2:
			_flow_worker.add_actions(actions)
			_flow_worker.start_processing()
		3:
			_flow_worker.add_actions(actions, true)
		4:
			FlowWorker.run(self, actions, true)
		5:
			_flow_worker.processing_started.connect(_processing_state.bind(1))
			_flow_worker.processing_ended.connect(_processing_state.bind(2))
			_flow_worker.add_actions(actions, true)
		6:
			_flow_worker.processing_started.connect(_processing_state.bind(1))
			_flow_worker.processing_ended.connect(_processing_state.bind(2))
			_flow_worker.processing_cancelled.connect(_processing_state.bind(3))
			_flow_worker.add_actions(actions, true)
			_flow_worker.cancel_processing()

func _callable_test() -> void:
	print("Called callable function")

func _processing_state(state: int) -> void:
	print("Processing state %d" % state)
	if state >= 2:
		_flow_worker.processing_started.disconnect(_processing_state)
		_flow_worker.processing_ended.disconnect(_processing_state)
