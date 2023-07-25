@icon("res://scripts/state.svg")
class_name State
extends Node2D


@onready var state_machine := get_parent() as StateMachine


func transition_to(new_state: State) -> void:
	state_machine.transition_to(new_state)


func transition_to_last_state() -> void:
	state_machine.transition_to_last_state()


func enter() -> void:
	pass


func exit() -> void:
	pass


func process(delta: float) -> void:
	pass


func physics_process(delta: float) -> void:
	pass
