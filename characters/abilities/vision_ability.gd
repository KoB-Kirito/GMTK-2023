extends Node2D


const HINT_MARGIN: float = 20
const VIEWPORT_SIZE: Vector2 = Vector2(480, 270)

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var target: Node2D


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ability_vision"):
		return
	
	if target == null:
		target = get_tree().get_first_node_in_group("vision_target")
	
	if target == null:
		return
	
	sprite.play("default")


func _physics_process(delta: float) -> void:
	if target == null:
		return
	
	var viewport_position = get_viewport_transform().origin * -1
	
	var hint_position = target.position
	# keep x on screen
	if hint_position.x < viewport_position.x + HINT_MARGIN:
		hint_position.x = viewport_position.x + HINT_MARGIN
	
	elif hint_position.x > viewport_position.x + VIEWPORT_SIZE.x - HINT_MARGIN:
		hint_position.x = viewport_position + VIEWPORT_SIZE.x - HINT_MARGIN
	
	# keep y on screen
	if hint_position.y < viewport_position.y + HINT_MARGIN:
		hint_position.y = viewport_position.y + HINT_MARGIN
	
	elif hint_position.y > viewport_position.y + VIEWPORT_SIZE.y - HINT_MARGIN:
		hint_position.y = viewport_position + VIEWPORT_SIZE.y - HINT_MARGIN
	
	sprite.position = hint_position
	
