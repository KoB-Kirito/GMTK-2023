class_name PatrolPointData
extends Resource


## How long the unit stops here
@export var look_duration: float = 0.0
@export var look_right: bool = true
@export var look_down: bool = true
@export var look_left: bool = true
@export var look_up: bool = true
## How the unit cycles through directions
@export_enum("Clockwise", "Counter-clockwise", "Random") var look_mode: int = 0
## How long until the unit changes direction
@export var look_cycle_duration: float = 4.0
