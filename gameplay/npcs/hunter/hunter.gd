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
			detect_right()
		update_configuration_warnings()
		notify_property_list_changed()
var look_down: bool = true:
	set(value):
		look_down = value
		if value:
			face_down()
			detect_down()
		update_configuration_warnings()
		notify_property_list_changed()
var look_left: bool = true:
	set(value):
		look_left = value
		if value:
			face_left()
			detect_left()
		update_configuration_warnings()
		notify_property_list_changed()
var look_up: bool = true:
	set(value):
		look_up = value
		if value:
			face_up()
			detect_up()
		update_configuration_warnings()
		notify_property_list_changed()
var look_duration: float = 10.0
var look_mode: int = 0
var look_current: Vector2 = Vector2.RIGHT

# path settings
## Create a path using path nodes, provide path name without numbers
var path_name: String

var detection_player_in_cone: bool = false
var detection_sees_player: bool = false

@onready var player := get_tree().get_first_node_in_group("player") as Player


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	match mode:
		0: # stationary
			if [look_right, look_down, look_left, look_up].count(true) > 1:
				%CycleTimer.wait_time = look_duration
				%CycleTimer.start()
			
		1: # follow path
			# ToDo
			pass


func _physics_process(delta: float) -> void:
	if detection_player_in_cone:
		detect_player()
		
		if detection_sees_player:
			if !%DetectionRay.is_colliding() or !%DetectionRay.get_collider() is Player:
				lose_player()
			
		else:
			if %DetectionRay.is_colliding() and %DetectionRay.get_collider() is Player:
				see_player()
		
	elif detection_sees_player:
		lose_player()


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
	if is_node_ready():
		%Sprite.frame_coords.y = 0
		look_current = Vector2.RIGHT

func detect_right():
	if is_node_ready():
		%DetectionArea.rotation_degrees = 0
		%DetectionRay.rotation_degrees = 0


func face_down():
	if is_node_ready():
		%Sprite.frame_coords.y = 2
		look_current = Vector2.DOWN

func detect_down():
	if is_node_ready():
		%DetectionArea.rotation_degrees = 90
		%DetectionRay.rotation_degrees = 90


func face_left():
	if is_node_ready():
		%Sprite.frame_coords.y = 1
		look_current = Vector2.LEFT

func detect_left():
	if is_node_ready():
		%DetectionArea.rotation_degrees = 180
		%DetectionRay.rotation_degrees = 180

func face_up():
	if is_node_ready():
		%Sprite.frame_coords.y = 3
		look_current = Vector2.UP

func detect_up():
	if is_node_ready():
		%DetectionArea.rotation_degrees = 270
		%DetectionRay.rotation_degrees = 270


func detect_player():
	%DetectionArea.look_at(player.position)
	%DetectionRay.look_at(player.position)


func see_player():
	detection_sees_player = true
	%Danger.visible = true
	%Danger2.visible = false
	%ResetTimer.stop()
	Globals.hunter_saw_player.emit()


func lose_player():
	detection_sees_player = false
	%Danger.visible = false
	%Danger2.visible = true
	%ResetTimer.start()


func _on_reset_timer_timeout() -> void:
	# hunter lost player long enough
	
	%Danger2.visible = false
	
	# ToDo: move back to starting position
	
	# reset look
	_on_cycle_timer_timeout()
	
	Globals.hunter_lost_player.emit()


## stationary look around
func _on_cycle_timer_timeout() -> void:
	if detection_sees_player:
		return
	
	match look_mode:
		0: # clockwise
			match look_current:
				Vector2.RIGHT:
					if look_down:
						face_down()
						detect_down()
					elif look_left:
						face_left()
						detect_left()
					elif look_up:
						face_up()
						detect_up()
				
				Vector2.DOWN:
					if look_left:
						face_left()
						detect_left()
					elif look_up:
						face_up()
						detect_up()
					elif look_right:
						face_right()
						detect_right()
				
				Vector2.LEFT:
					if look_up:
						face_up()
						detect_up()
					elif look_right:
						face_right()
						detect_right()
					elif look_down:
						face_down()
						detect_down()
				
				Vector2.UP:
					if look_right:
						face_right()
						detect_right()
					elif look_down:
						face_down()
						detect_down()
					elif look_left:
						face_left()
						detect_left()
		
		1: # counter-clockwise
			match look_current:
				Vector2.RIGHT:
					if look_up:
						face_up()
						detect_up()
					elif look_left:
						face_left()
						detect_left()
					elif look_down:
						face_down()
						detect_down()
				
				Vector2.UP:
					if look_left:
						face_left()
						detect_left()
					elif look_down:
						face_down()
						detect_down()
					elif look_right:
						face_right()
						detect_right()
				
				Vector2.LEFT:
					if look_down:
						face_down()
						detect_down()
					elif look_right:
						face_right()
						detect_right()
					elif look_up:
						face_up()
						detect_up()
				
				Vector2.DOWN:
					if look_right:
						face_right()
						detect_right()
					elif look_up:
						face_up()
						detect_up()
					elif look_left:
						face_left()
						detect_left()
		
		2: # random, but new direction every time
			while true:
				match randi() % 4:
					0:
						if look_current != Vector2.RIGHT and look_right:
							face_right()
							detect_right()
							break
					
					1:
						if look_current != Vector2.DOWN and look_down:
							face_down()
							detect_down()
							break
					
					2:
						if look_current != Vector2.LEFT and look_left:
							face_left()
							detect_left()
							break
					
					3:
						if look_current != Vector2.UP and look_up:
							face_up()
							detect_up()
							break


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		detection_player_in_cone = true
		%DetectionRay.enabled = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		detection_player_in_cone = false
		%DetectionRay.enabled = false


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
