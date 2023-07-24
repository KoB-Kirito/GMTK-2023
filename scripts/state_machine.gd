@icon("res://scripts/state_machine.svg")
class_name StateMachine
extends Node


@export var initial_state: State

var states: Dictionary
var current_state: State


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(on_transition)
	
	if initial_state != null:
		initial_state.enter()
		current_state = initial_state


func _process(delta: float) -> void:
	if current_state != null:
		current_state.process(delta)


func _physics_process(delta: float) -> void:
	if current_state != null:
		current_state.physics_process(delta)


func on_transition(calling_state: State, new_state_name: String):
	if calling_state != current_state:
		return
	
	var new_state := states.get(new_state_name.to_lower()) as State
	if new_state == null:
		return
	
	if current_state != null:
		current_state.exit()
	
	new_state.enter()
