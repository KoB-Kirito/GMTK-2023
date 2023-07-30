@tool
class_name Npc
extends CharacterBody2D


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

@export_enum("Right", "Left", "Down", "Up") var look = 2:
	set(value):
		look = value
		if Engine.is_editor_hint():
			%Sprite.frame_coords.y = value

var player: Player:
	get:
		if player:
			return player
		player = get_tree().get_first_node_in_group("player")
		return player


func _ready() -> void:
	# don't run in editor
	if Engine.is_editor_hint():
		return
	
	%DebugLabel.visible = false
	%Sprite.texture = sprite
	%Sprite.frame_coords.y = look


func _physics_process(delta: float) -> void:
	# don't run in editor
	if Engine.is_editor_hint():
		return
	
	animation()


## Handles animation based on current movement
func animation():
	# stop animation if not moving
	var current_speed = velocity.length_squared()
	if current_speed == 0.0:
		%AnimationTimer.stop()
		%Sprite.frame_coords.x = 1
		return
	
	# set animation tempo based on current speed
	%AnimationTimer.wait_time = 0.9 - sqrt(current_speed) / 125.0
	
	if %AnimationTimer.is_stopped():
		%AnimationTimer.start()
	
	# change direction based on current movement direction
	# assumes that the sprite has a column for each direction: 0 = right, 1 = left, 2 = down, 3 = up
	match velocity.normalized().snapped(Vector2.ONE):
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
	%Sprite.frame_coords.y = look
	# ToDo: continue with path here, if npc is walking
	
