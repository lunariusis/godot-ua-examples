class_name FlowAction extends Node


signal next_action

## This method should be overridden by specific FlowAction classes.
## It should invoke the desired action and return a signal for await, or null if no action is required.
func execute() -> Signal:
	printerr("FlowAction: the execute() method must be overridden!")
	return next_action
