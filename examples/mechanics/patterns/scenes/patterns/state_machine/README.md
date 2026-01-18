# State Machine Example

This example demonstrates a robust implementation of the State Machine design pattern in Godot Engine, specifically applied to a traffic light system. It showcases a clear separation of concerns, following principles similar to Model-View-Controller (MVC) or Model-View-Presenter (MVP).

## Features:
-   **Generic State Machine:** A reusable `StateMachine` class that manages state transitions independently of scene nodes.
-   **Abstract State Class:** A `State` base class defining the interface for concrete states.
-   **Decoupled View:** A dedicated `TrafficLightView` responsible solely for visual representation.
-   **Controller Logic:** A main script (`state_pattern_main.gd`) that orchestrates the FSM, handles user input, and updates the view.
-   **Concrete States:** Multiple states (Red, Green, Yellow transitions) demonstrating specific behaviors.

## How to Use:
1.  Open the `state_machine_example.tscn` scene in the Godot Editor.
2.  Run the scene.
3.  Press the "Next State" button to cycle through the traffic light states.
4.  Press the "<-" button in the top-left corner to return to the main menu (placeholder functionality).

## Example Requirements:
-   **Requires Godot 4.5 or newer**
-   **Difficulty:** Intermediate
-   **Tags:** `FSM`, `State Pattern`, `GDScript`, `UI`, `Design Patterns`
