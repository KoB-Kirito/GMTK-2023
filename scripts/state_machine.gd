@icon("res://scripts/state_machine.svg")
class_name StateMachine
extends Node2D


signal state_changed(old_state: State, new_state: State)

@export var initial_state: State

var last_state: State
var current_state: State


func _ready() -> void:
	if initial_state != null:
		current_state = initial_state
		initial_state.enter()
		state_changed.emit(null, current_state)


func _process(delta: float) -> void:
	if current_state != null:
		current_state.process(delta)


func _physics_process(delta: float) -> void:
	if current_state != null:
		current_state.physics_process(delta)


func _unhandled_input(event: InputEvent) -> void:
	if current_state != null:
		current_state.unhandled_input(event)


func transition_to(new_state: State):
	if current_state != null:
		current_state.exit()
	
	last_state = current_state
	current_state = new_state
	
	current_state.enter()
	
	state_changed.emit(last_state, current_state)
