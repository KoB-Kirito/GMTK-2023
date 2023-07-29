@icon("res://scripts/state_machine.svg")
class_name StateMachine
extends Node2D


signal state_changed(old_state: State, new_state: State)

@export var initial_state: State

var current_state: State
var last_state: State


func _enter_tree() -> void:
	for node in get_children_recursive(self):
		if node is State:
			node.ready.connect(set_processing.bind(node, false))
			node.state_machine = self

func _ready() -> void:
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
	node.set_process(enable)
	node.set_physics_process(enable)
	node.set_process_input(enable)
	node.set_process_unhandled_input(enable)
	node.set_process_unhandled_key_input(enable)
