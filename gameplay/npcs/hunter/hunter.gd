@tool
class_name Hunter
extends CharacterBody2D
## Enemy class


## The path this hunter will follow. If set, the path will determine it's behavior at each point.
@export var patrol_path: PatrolPath:
	set(value):
		patrol_path = value
		notify_property_list_changed()

## Data for stationary behavior, if not used on a path
var patrol_data: PatrolPointData:
	set(value):
		patrol_data = value
		update_configuration_warnings()


var look_current: Vector2 = Vector2.RIGHT


#func _init():
#	for info in get_property_list():
#		print(info)


func _physics_process(delta: float) -> void:
	animation()


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
	if %Sprite.frame_coords.x == 2:
		%Sprite.frame_coords.x = 0
		
	else:
		%Sprite.frame_coords.x += 1


func face_right():
	if is_node_ready():
		%Sprite.frame_coords.y = 0
		%PlayerDetector.rotation_degrees = 0
		look_current = Vector2.RIGHT

func face_down():
	if is_node_ready():
		%Sprite.frame_coords.y = 2
		%PlayerDetector.rotation_degrees = 90
		look_current = Vector2.DOWN

func face_left():
	if is_node_ready():
		%Sprite.frame_coords.y = 1
		%PlayerDetector.rotation_degrees = 180
		look_current = Vector2.LEFT

func face_up():
	if is_node_ready():
		%Sprite.frame_coords.y = 3
		%PlayerDetector.rotation_degrees = 270
		look_current = Vector2.UP



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
