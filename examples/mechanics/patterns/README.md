# State Machine Pattern Example

**Difficulty:** Intermediate
**Tags:** `State Pattern`, `FSM`, `GDScript`, `Design Pattern`

This example demonstrates the **State design pattern** using a Finite State Machine (FSM) to control the behavior of a traffic light. It showcases how to separate the logic for each state into its own class, making the code more organized, extensible, and easier to maintain.

## Features

- A clear and simple implementation of a Finite State Machine (FSM).
- Separation of state-specific logic into individual `State` classes.
- Centralized state management that can be easily observed and controlled.
- Demonstrates how states can independently manage behavior and transitions.
- UI for visualizing the current state and triggering state transitions.

## How to Use

1.  Open the `patterns` folder as a project in Godot Engine.
2.  Open the `scenes/patterns/state_machine/state_machine_example.tscn` scene.
3.  Run the scene (F6).
4.  You will see a visual representation of a traffic light.
5.  Press the "Perform Action" button to trigger the `handle_action` method on the current state, causing a transition to the next state in the sequence.
6.  The "Current State" label displays the name of the active state.

- To see how the FSM is initialized, check `scenes/patterns/state_machine/state_pattern_main.gd`.
- To understand the core FSM logic, see `scenes/patterns/state_machine/fsm/state_machine.gd`.
- To see how individual states are implemented, explore the scripts in the `scenes/patterns/state_machine/states/` folder.

## Requires

Godot 4.5 (may work on Godot 4.x or newer).
