@icon("res://scripts/state.svg")
class_name State
extends Node


signal transition(calling_state: State, new_state_name: String)


func enter() -> void:
	pass


func exit() -> void:
	pass


func process(delta: float) -> void:
	pass


func physics_process(delta: float) -> void:
	pass
