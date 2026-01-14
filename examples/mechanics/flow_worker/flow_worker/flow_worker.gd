class_name FlowWorker extends Node


## Alternative, concise way to execute a sequence of actions as a one-liner.
## Creates a worker, adds it to the parent, loads actions, and runs them.
## By default, the worker is one-shot and will free itself when done.
## @param parent The Node to which the worker will be added as a child.
## @param actions An array of FlowAction instances to execute.
## @param one_shot If true, the worker will be freed after completion.
## @return The newly created and started FlowWorker instance.
static func run(parent: Node, actions: Array, one_shot: bool = true) -> FlowWorker:
	if not is_instance_valid(parent):
		push_error("FlowWorker.run() failed: Parent node is not valid.")
		return null

	var worker = FlowWorker.new()
	parent.add_child(worker)

	if actions: # Check if the array itself is not null
		for action in actions:
			# Check if the action is valid before adding
			if is_instance_valid(action):
				# We call add_action without autostart here, as we will start it manually at the end.
				worker.add_action(action, false)
			else:
				push_warning("FlowWorker.run() skipped an invalid action in the provided array.")
	
	worker.start_processing(one_shot)
	return worker


## Emitted when the worker starts processing the action queue.
signal processing_started
## Emitted when the worker finishes the entire queue naturally.
signal processing_ended
## Emitted when processing is cancelled via the cancel_processing() method.
signal processing_cancelled

var _action_queue: Array[FlowAction] = []
var _is_processing: bool = false
var _is_one_shot: bool = false



## Adds an action to the queue and adds it to the scene tree.
## @param action The FlowAction to be added.
## @param autostart If true, starts processing the queue immediately if not already processing.
func add_action(action: FlowAction, autostart: bool = false) -> void:
	if not is_instance_valid(action):
		push_error("FlowWorker.add_action() failed: The provided action is not a valid instance.")
		return

	add_child(action)
	_action_queue.append(action)
	
	if not _is_processing and autostart:
		start_processing()


## Adds an array of actions to the queue.
## @param actions The Array of FlowAction instances to be added.
## @param autostart If true, starts processing the queue immediately if not already processing.
func add_actions(actions: Array[FlowAction], autostart: bool = false):
	for action in actions:
		# Add each action without autostarting
		add_action(action, false)
	
	if not _is_processing and autostart:
		start_processing()


## Starts processing the action queue if it's not already processing.
## @param one_shot If true, the worker will automatically be freed from the scene after the queue is empty.
func start_processing(one_shot: bool = false):
	if _is_processing:
		return
	
	_is_one_shot = one_shot
	_is_processing = true
	processing_started.emit()
	_process_next_action_in_queue()


## Cancels the processing of the action queue.
## All pending actions will be cleared. The currently executing action will
## finish, but no new actions will be started.
## Emits the `processing_cancelled` signal.
func cancel_processing():
	if not _is_processing:
		return
	
	_action_queue.clear()
	_is_processing = false
	processing_cancelled.emit()


## Processes the action queue sequentially using a recursive-like pattern.
## This ensures that asynchronous actions are handled correctly.
func _process_next_action_in_queue():
	if not _action_queue.is_empty():
		var current_action = _action_queue.pop_front()
		var completion_signal = current_action.execute()
		
		# Wait for completion only if the signal is valid
		if completion_signal is Signal and completion_signal.get_name() != "next_action":
			await completion_signal
		
		current_action.queue_free()
		
		# Recursively call to process the next action
		_process_next_action_in_queue()
	else:
		# If the queue is empty, finish processing
		if _is_processing:
			_is_processing = false
			processing_ended.emit()
			# If it's a one-shot worker, free it after it's done.
			if _is_one_shot:
				queue_free()
