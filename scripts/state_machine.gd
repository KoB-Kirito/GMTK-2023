@icon("res://scripts/state_machine.svg")
class_name StateMachine
extends Node


signal state_changed(old_state: State, new_state: State)

@export var initial_state: State

var current_state: State
var last_state: State


func _ready() -> void:
	for node in get_children_recursive(self):
		print(node)
		if node is State:
			set_processing(node, false)
			node.state_machine = self
	
	if initial_state != null:
		change_state(initial_state)


func change_state(new_state: State):
	if current_state != null:
		set_processing(current_state, false)
		current_state._exit_state()
	
	last_state = current_state
	current_state = new_state
	
	current_state._enter_state()
	set_processing(current_state, true)
	
	state_changed.emit(last_state, current_state)


## Returns all children of node recursively. Will include self at first position
func get_children_recursive(node: Node, nodes: Array[Node] = []) -> Array[Node]:
	nodes.push_back(node)
	for child in node.get_children():
		nodes = get_children_recursive(child, nodes)
	return nodes


func set_processing(node: Node, enable: bool) -> void:
	set_process(enable)
	set_physics_process(enable)
	set_process_input(enable)
	set_process_unhandled_input(enable)
	set_process_unhandled_key_input(enable)
