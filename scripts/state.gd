@icon("res://scripts/state.svg")
class_name State
extends Node2D


var state_machine: StateMachine:
	get:
		if state_machine == null:
			var parent = get_parent()
			while true:
				if parent == null:
					break
				if parent is StateMachine:
					state_machine = parent
					break
				parent = parent.get_parent()
		return state_machine

var last_state: State:
	get:
		return state_machine.last_state


func enter() -> void:
	pass


func exit() -> void:
	pass


func process(delta: float) -> void:
	pass


func physics_process(delta: float) -> void:
	pass


func unhandled_input(event: InputEvent) -> void:
	pass


func transition_to(new_state: State) -> void:
	state_machine.transition_to(new_state)
