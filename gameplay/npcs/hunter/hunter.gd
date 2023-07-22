@tool
class_name Hunter
extends CharacterBody2D
## Enemy class


@export_enum("Stationary", "Follow Path") var mode: int = 0:
	set(value):
		mode = value
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
var look_duration: float = 10.0
var look_mode: int = 0

# path settings
## Create a path using path nodes, provide path name without numbers
var path_name: String


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func _process(delta: float) -> void:
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
	%Sprite.frame_coords.y = 0
	%DetectionArea.rotation_degrees = 0


func face_down():
	%Sprite.frame_coords.y = 2
	%DetectionArea.rotation_degrees = 90


func face_left():
	%Sprite.frame_coords.y = 1
	%DetectionArea.rotation_degrees = 180


func face_up():
	%Sprite.frame_coords.y = 3
	%DetectionArea.rotation_degrees = 270


## debug movement
#var ispeed = 50
#
#func _physics_process(delta: float) -> void:
#	movement(delta)
#
#func movement(_delta: float) -> void:
#	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
#	velocity = direction * ispeed
#	move_and_slide()


## editor only
func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary]
	
	match mode:
		0:
			properties.append({
				"name": "Stationary Settings",
				"type": TYPE_STRING,
				"usage": PROPERTY_USAGE_GROUP,
			})
			properties.append({
				"name": "look_right",
				"type": TYPE_BOOL,
			})
			properties.append({
				"name": "look_down",
				"type": TYPE_BOOL,
			})
			properties.append({
				"name": "look_left",
				"type": TYPE_BOOL,
			})
			properties.append({
				"name": "look_up",
				"type": TYPE_BOOL,
			})
			if [look_right, look_down, look_left, look_up].count(true) > 1:
				properties.append({
					"name": "look_duration",
					"type": TYPE_FLOAT,
				})
				properties.append({
					"name": "look_mode",
					"type": TYPE_INT,
					"hint": PROPERTY_HINT_ENUM,
					"hint_string": "Clockwise,Counterclockwise,Random"
				})
		
		1:
			properties.append({
				"name": "Path Settings",
				"type": TYPE_STRING,
				"usage": PROPERTY_USAGE_GROUP,
			})
			properties.append({
				"name": "path_name",
				"type": TYPE_STRING,
			})
	
	return properties


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	
	if mode == 0:
		if !look_right and !look_down and !look_left and !look_up:
			warnings.append("You must enable at least one look direction if stationary")
	
	return warnings
	
