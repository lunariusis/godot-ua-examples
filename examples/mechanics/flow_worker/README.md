# FlowWorker Example

**Difficulty:** Intermediate  
**Tags:** `Async`, `Sequence`, `Flow Control`, `GDScript`

This example demonstrates a `FlowWorker` node that executes a sequence of actions in a predefined order. It is useful for managing game flow, creating cutscenes, tutorials, or any scenario that requires a chain of synchronous or asynchronous events.

## Features

- Sequential execution of synchronous and asynchronous actions.
- A concise static `run()` method for simple, one-liner execution flows.
- Easily extensible by creating custom `FlowAction` classes.
- Demonstrates both instance-based and static approaches to managing action queues.

## How to Use

1.  Open the `flow_worker` folder as a project in Godot Engine.
2.  Run the project (F5). The main scene `main.tscn` will be launched automatically.
3.  Explore `scenes/level.gd` to see four different examples of how to use the `FlowWorker`.
4.  Explore the `flow_worker/actions` folder to understand how `ActionPause` and `ActionCallCallable` are implemented.

## Creating Custom Actions

You can easily create your own actions by extending `FlowAction`.

1.  Create a new script that extends `FlowAction`.
2.  Add `class_name YourActionName` to make it easy to instantiate.
3.  Override the `execute()` method.

The `execute()` method must return a `Signal`. The `FlowWorker` will wait for this signal before proceeding to the next action. If your action is synchronous (completes instantly), you can simply return `null` or the built-in `next_action` signal.

**Example: A custom action that moves a node.**

```gdscript
# move_action.gd
class_name MoveAction extends FlowAction

var _node: Node2D
var _target_position: Vector2
var _duration: float

func _init(node: Node2D, target_pos: Vector2, duration: float):
    _node = node
    _target_position = target_pos
    _duration = duration

func execute() -> Signal:
    if not is_instance_valid(_node):
        printerr("MoveAction: Node is not valid.")
        return next_action # or return null
        
    var tween = get_tree().create_tween()
    tween.tween_property(_node, "global_position", _target_position, _duration)
    
    # The FlowWorker will wait until the tween is finished.
    return tween.finished
```

## Requires

Godot 4.5 (may work on Godot 4.x or newer).