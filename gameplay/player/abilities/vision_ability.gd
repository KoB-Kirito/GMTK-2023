extends Node2D


@export var progress: TextureProgressBar

const HINT_MARGIN: int = 20
const VIEWPORT_SIZE: Vector2 = Vector2(480, 270)

var target: Node2D


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ability_vision"):
		return
	
	if target == null:
		target = get_tree().get_first_node_in_group("vision_target")
	
	if target == null:
		print_debug("vision ability found no target")
		progress.value = 0.0
		progress.play_deny_animation()
		return
	
	if progress.value < 100.0:
		progress.play_deny_animation()
		return
	
	progress.value = 0.0
	%Hint.play("splosh")


func _physics_process(delta: float) -> void:
	if target == null:
		return
	
	#print("viewport_transform", get_viewport_transform())
	#print("screen_transform", get_screen_transform())
	#print("canvas_transform", get_canvas_transform())
	#print("canvas_affine", get_canvas_transform().affine_inverse()) !
	#print("global_transform", get_global_transform())
	#print("global_w_canvas", get_global_transform_with_canvas())
	
	var canvas_position = get_canvas_transform().affine_inverse().origin
	
	var hint_position = target.position
	
	# keep x on screen
	if hint_position.x < canvas_position.x + HINT_MARGIN:
		hint_position.x = canvas_position.x + HINT_MARGIN
	
	elif hint_position.x > canvas_position.x + VIEWPORT_SIZE.x - HINT_MARGIN:
		hint_position.x = canvas_position + VIEWPORT_SIZE.x - HINT_MARGIN
	
	# keep y on screen
	if hint_position.y < canvas_position.y + HINT_MARGIN:
		hint_position.y = canvas_position.y + HINT_MARGIN
	
	elif hint_position.y > canvas_position.y + VIEWPORT_SIZE.y - HINT_MARGIN:
		hint_position.y = canvas_position.y + VIEWPORT_SIZE.y - HINT_MARGIN
	
	position = hint_position


func _process(delta: float) -> void:
	if target == null:
		return
	
	if progress.value < 100.0:
		progress.value += 5.0 * delta
