extends Node2D


const COOLDOWN: float = 5.0
const HINT_MARGIN: float = 20.0

@export var progress: TextureProgressBar
@export var label: Label

@onready var viewport_size: Vector2 = get_viewport().size


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ability_vision"):
		return
	
	if progress.value < 100.0:
		progress.play_deny_animation()
		return
	
	var target = get_nearest_target(get_targets())
	
	if target == null:
		print_debug("vision ability found no target")
		progress.value = 0.0
		progress.play_deny_animation()
		return
	
	progress.value = 0.0
	%Hint.play("splosh")


func _physics_process(delta: float) -> void:
	var target = get_nearest_target(get_targets())
	if target == null:
		progress.value = 0.0
		return
	
	update_cooldown(delta)
	
	if not %Hint.is_playing():
		return
	
	var canvas_position = get_canvas_transform().affine_inverse().origin
	
	var hint_position = target.global_position
	
	# keep x on screen
	if hint_position.x < canvas_position.x + HINT_MARGIN:
		hint_position.x = canvas_position.x + HINT_MARGIN
	
	elif hint_position.x > canvas_position.x + viewport_size.x - HINT_MARGIN:
		hint_position.x = canvas_position + viewport_size.x - HINT_MARGIN
	
	# keep y on screen
	if hint_position.y < canvas_position.y + HINT_MARGIN:
		hint_position.y = canvas_position.y + HINT_MARGIN
	
	elif hint_position.y > canvas_position.y + viewport_size.y - HINT_MARGIN:
		hint_position.y = canvas_position.y + viewport_size.y - HINT_MARGIN
	
	%Hint.global_position = hint_position


func get_targets() -> Array[Node]:
	var targets := get_tree().get_nodes_in_group("vision_target")
	if targets.size() == 0:
		label.hide()
		return targets
	
	label.text = str(targets.size())
	return targets


func get_nearest_target(targets: Array[Node]) -> Node2D:
	var nearest: Node2D
	for node in targets:
		if nearest == null:
			nearest = node
			continue
		
		if global_position.distance_squared_to(node.global_position) < global_position.distance_squared_to(nearest.global_position):
			nearest = node
	return nearest


func update_cooldown(delta: float):
	if progress.value < 100.0:
		progress.value += COOLDOWN * delta
