@tool
class_name Hunter
extends CharacterBody2D
## Enemy class


## The path this hunter will follow. If set, the path will determine it's behavior at each point.
@export var patrol_path: PatrolPath:
	set(value):
		patrol_path = value
		notify_property_list_changed()

# stationary settings
var look_right: bool = true:
	set(value):
		look_right = value
		if value:
			face_right()
		update_configuration_warnings()
		notify_property_list_changed()
var look_down: bool = true:
	set(value):
		look_down = value
		if value:
			face_down()
		update_configuration_warnings()
		notify_property_list_changed()
var look_left: bool = true:
	set(value):
		look_left = value
		if value:
			face_left()
		update_configuration_warnings()
		notify_property_list_changed()
var look_up: bool = true:
	set(value):
		look_up = value
		if value:
			face_up()
		update_configuration_warnings()
		notify_property_list_changed()
var cycle_mode: int = 0:
	set(value):
		cycle_mode = value
		update_configuration_warnings()
		notify_property_list_changed()
## If enabled, random will pick a new direction everytime
var always_new: bool = true
## Minimum duration until direction is cycled, in seconds
var duration_min: float = 2.0:
	set(value):
		duration_min = value
		if duration_max < duration_min:
			duration_max = duration_min
## Maximum duration until direction is cycled, in seconds
var duration_max: float = 4.0:
	set(value):
		duration_max = value
		if duration_min > duration_max:
			duration_min = duration_max


var look_current: Vector2 = Vector2.RIGHT


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
func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary]
	
	if patrol_path == null:
		properties.append({
			"name": "Stationary Settings",
			"type": TYPE_STRING,
			"usage": PROPERTY_USAGE_GROUP,
		})
		properties.append({
			"name": "look_right",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		properties.append({
			"name": "look_down",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		properties.append({
			"name": "look_left",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		properties.append({
			"name": "look_up",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		if [look_right, look_down, look_left, look_up].count(true) > 1:
			properties.append({
			"name": "Cycle Directions",
			"type": TYPE_STRING,
			"usage": PROPERTY_USAGE_GROUP,
			})
			
			if [look_right, look_down, look_left, look_up].count(true) > 2:
				properties.append({
					"name": "cycle_mode",
					"type": TYPE_INT,
					"usage": PROPERTY_USAGE_DEFAULT,
					"hint": PROPERTY_HINT_ENUM,
					"hint_string": "Clockwise,Counter-clockwise,Random"
				})
				
				if cycle_mode == 2:
					properties.append({
						"name": "always_new",
						"type": TYPE_BOOL,
						"usage": PROPERTY_USAGE_DEFAULT,
					})
			
			properties.append({
				"name": "duration_min",
				"type": TYPE_FLOAT,
				"usage": PROPERTY_USAGE_DEFAULT,
			})
			properties.append({
				"name": "duration_max",
				"type": TYPE_FLOAT,
				"usage": PROPERTY_USAGE_DEFAULT,
			})
	
	return properties


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	
	if patrol_path == null:
		if !look_right and !look_down and !look_left and !look_up:
			warnings.append("You must enable at least one look direction if stationary")
	
	return warnings
