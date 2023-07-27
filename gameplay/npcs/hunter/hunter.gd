@tool
class_name Hunter
extends CharacterBody2D
## Enemy class


## Can be overridden by the partol path
@export var default_speed: float = 40.0
@export var chasing_speed: float = 60.0
var current_speed: float = default_speed

@export_group("Behavior")
## The path this hunter will follow. If set, the path will determine it's behavior at each point.
@export var patrol_path: PatrolPath:
	set(value):
		patrol_path = value
		notify_property_list_changed()

## Data for stationary behavior. Ignored if path is set.
var patrol_data: PatrolPointData:
	set(value):
		patrol_data = value
		update_configuration_warnings()

var current_facing: Vector2 = Vector2.RIGHT
var paused: bool = true


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	assert(patrol_path or patrol_data, "No path and no data")
	
	# conditional entry point
	var state_machine := $StateMachine as StateMachine
	if patrol_path != null:
		state_machine.transition_to(%Patrolling)
	else:
		state_machine.transition_to(%Watching)


func _physics_process(delta: float) -> void:
	if paused:
		return
	
	if Engine.is_editor_hint():
		return
	
	move_to_target()
	animation()


func move_to_target():
	if %Navigation.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	
	var next_path_position: Vector2 = %Navigation.get_next_path_position()
	
	var new_velocity: Vector2 = next_path_position - global_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * current_speed
	
	velocity = new_velocity
	move_and_slide()


func animation():
	var speed = velocity.length_squared()
	if speed == 0.0:
		%AnimationTimer.stop()
		%Sprite.frame_coords.x = 1
		return
	
	if %AnimationTimer.is_stopped():
		%AnimationTimer.start()
	
	%AnimationTimer.wait_time = 0.9 - sqrt(speed) / 125.0
	
	match velocity.normalized().snapped(Vector2.ONE):
		Vector2.RIGHT:
			face_right()
			
		Vector2.DOWN:
			face_down()
			
		Vector2.LEFT:
			face_left()
			
		Vector2.UP:
			face_up()


func _on_animation_timer_timeout() -> void:
	if paused:
		return
	
	if %Sprite.frame_coords.x == 2:
		%Sprite.frame_coords.x = 0
		
	else:
		%Sprite.frame_coords.x += 1


func face_right():
	if is_node_ready():
		%Sprite.frame_coords.y = 0
		%PlayerDetector.rotation_degrees = 0
		current_facing = Vector2.RIGHT

func face_down():
	if is_node_ready():
		%Sprite.frame_coords.y = 2
		%PlayerDetector.rotation_degrees = 90
		current_facing = Vector2.DOWN

func face_left():
	if is_node_ready():
		%Sprite.frame_coords.y = 1
		%PlayerDetector.rotation_degrees = 180
		current_facing = Vector2.LEFT

func face_up():
	if is_node_ready():
		%Sprite.frame_coords.y = 3
		%PlayerDetector.rotation_degrees = 270
		current_facing = Vector2.UP


## Pause when not on screen
func _on_visible_notifier_screen_entered() -> void:
	paused = false

func _on_visible_notifier_screen_exited() -> void:
	paused = true


## editor only
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_EDITOR_PRE_SAVE:
			update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	
	if patrol_path == null and patrol_data == null:
		warnings.append("Set either patrol path or patrol data for behavior")
	
	if patrol_path == null and patrol_data != null:
		if !patrol_data.look_right and !patrol_data.look_down and !patrol_data.look_left and !patrol_data.look_up:
			warnings.append("You must enable at least one look direction if stationary")
			
		elif patrol_data.look_right:
			face_right()
		elif patrol_data.look_down:
			face_down()
		elif patrol_data.look_left:
			face_left()
		elif patrol_data.look_up:
			face_up()
		
	return warnings

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary]
	
	if patrol_path == null:
		properties.append({
			"name": "patrol_data",
			"class_name": &"Resource",
			"type": TYPE_OBJECT,
			"hint": PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string": "PatrolPointData",
			"usage": PROPERTY_USAGE_DEFAULT,
		})
	
	return properties


func _on_state_machine_state_changed(old_state, new_state) -> void:
	%DebugLabel.text = new_state.name
