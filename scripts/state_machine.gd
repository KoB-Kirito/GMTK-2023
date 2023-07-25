@icon("res://scripts/state_machine.svg")
class_name StateMachine
extends Node2D


signal transitioned(old_state: State, new_state: State)

@export var initial_state: State

var last_state: State
var current_state: State


func _ready() -> void:
	if initial_state != null:
		current_state = initial_state
		initial_state.enter()
		transitioned.emit(null, current_state)


func _process(delta: float) -> void:
	if current_state != null:
		current_state.process(delta)


func _physics_process(delta: float) -> void:
	if current_state != null:
		current_state.physics_process(delta)


func transition_to(new_state: State):
	if current_state != null:
		current_state.exit()
	
	new_state.enter()
	last_state = current_state
	current_state = new_state
	transitioned.emit(last_state, current_state)


func transition_to_last_state():
	assert(last_state, "There is no last state")
	
	if current_state != null:
		current_state.exit()
	
	last_state.enter()
	var temp = last_state
	last_state = current_state
	current_state = temp
	transitioned.emit(last_state, current_state)
