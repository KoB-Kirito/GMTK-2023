@tool
class_name Npc
extends CharacterBody2D


## If true, will count as target for vision until talked to
@export var vision_target: bool = false

## Timeline name used when interacted with
@export var dialog_name: String:
	set(value):
		dialog_name = value
		if Engine.is_editor_hint():
			%DebugLabel.text = value

## Character sprite
@export var sprite: Texture2D:
	set(value):
		sprite = value
		if Engine.is_editor_hint():
			%Sprite.texture = value

## If true, character sprite only contains one image and character will always look down
@export var fixed: bool = false:
	set(value):
		fixed = value
		if Engine.is_editor_hint():
			if fixed:
				%Sprite.frame = 0
				%Sprite.hframes = 1
				%Sprite.vframes = 1
			else:
				%Sprite.hframes = 3
				%Sprite.vframes = 4
				%Sprite.frame_coords.y = look

@export_enum("Right", "Left", "Down", "Up") var look: int = 2:
	set(value):
		look = value
		if Engine.is_editor_hint():
			if not fixed:
				%Sprite.frame_coords.y = value

var last_position: Vector2

var player: Player:
	get:
		if player == null:
			player = get_tree().get_first_node_in_group("player")
		return player


func _enter_tree() -> void:
	if vision_target:
		add_to_group("vision_target")


func _ready() -> void:
	# don't run in editor
	if Engine.is_editor_hint():
		return
	
	last_position = global_position
	%DebugLabel.visible = false
	%Sprite.texture = sprite
	
	if fixed:
		%Sprite.frame = 0
		%Sprite.hframes = 1
		%Sprite.vframes = 1
		
	else:
		%Sprite.frame_coords.y = look


func _physics_process(delta: float) -> void:
	# don't run in editor
	if Engine.is_editor_hint():
		return
	
	animation()


## Handles animation based on current movement
func animation():
	if fixed:
		return
	
	if last_position == global_position:
		%AnimationTimer.stop()
		%Sprite.frame_coords.x = 1
		return
	
	var fake_velocity := global_position - last_position
	last_position = global_position
	
	# stop animation if not moving
	var current_speed = fake_velocity.length_squared()
	
	# set animation tempo based on current speed
	%AnimationTimer.wait_time = 0.9 - sqrt(current_speed) / 125.0
	
	if %AnimationTimer.is_stopped():
		%AnimationTimer.start()
	
	# change direction based on current movement direction
	# assumes that the sprite has a column for each direction: 0 = right, 1 = left, 2 = down, 3 = up
	match fake_velocity.normalized().snapped(Vector2.ONE):
		Vector2.RIGHT:
			%Sprite.frame_coords.y = 0
			
		Vector2.DOWN:
			%Sprite.frame_coords.y = 2
			
		Vector2.LEFT:
			%Sprite.frame_coords.y = 1
			
		Vector2.UP:
			%Sprite.frame_coords.y = 3


func _on_animation_timer_timeout() -> void:
	if %Sprite.frame_coords.x == 2:
		%Sprite.frame_coords.x = 0
		
	else:
		%Sprite.frame_coords.x += 1



### Interaction

var can_interact: bool = false
# should be able to use a shared static var instead of global, but buggy
#static var interacting: bool = false


## Set interactable based on player entering npcs interaction area
func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if Globals.interacting:
			return
		
		Globals.interacting = true
		can_interact = true

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if can_interact and body is Player:
		can_interact = false
		Globals.interacting = false


## Get interaction input and start dialog
func _unhandled_input(event: InputEvent) -> void:
	if not can_interact:
		return
	
	if event.is_action_pressed("interact"):
		face_player()
		Dialogic.timeline_ended.connect(on_dialog_ended)
		Dialogic.start(dialog_name.to_snake_case())


func face_player():
	if fixed:
		return
	
	match global_position.direction_to(player.global_position).snapped(Vector2.ONE):
		Vector2.RIGHT:
			%Sprite.frame_coords.y = 0
			
		Vector2.DOWN:
			%Sprite.frame_coords.y = 2
			
		Vector2.LEFT:
			%Sprite.frame_coords.y = 1
			
		Vector2.UP:
			%Sprite.frame_coords.y = 3


func on_dialog_ended():
	Dialogic.timeline_ended.disconnect(on_dialog_ended)
	# reset look
	if not fixed:
		%Sprite.frame_coords.y = look
	
	# only allow dialog one time
	%InteractionArea.body_entered.disconnect(_on_interaction_area_body_entered)
	%InteractionArea.body_exited.disconnect(_on_interaction_area_body_exited)
	can_interact = false
	Globals.interacting = false
	
	# healed
	if vision_target:
		remove_from_group("vision_target")
		Globals.npc_healed.emit()
