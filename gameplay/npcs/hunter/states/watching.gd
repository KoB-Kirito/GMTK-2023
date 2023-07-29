class_name WatchingState
extends State


var last_position: Vector2

var stay_duration: float

var look_right: bool
var look_down: bool
var look_left: bool
var look_up: bool

var cycle_mode: int
var always_new: bool
var cycle_duration_min: float
var cycle_duration_max: float

@onready var hunter := owner as Hunter


func _enter_state():
	get_data()
	
	%PlayerDetector.player_detected.connect(on_player_detected)
	
	if stay_duration > 0.0:
		%StayTimer.wait_time = stay_duration
		%StayTimer.start()
	
	if [look_right, look_down, look_left, look_up].count(true) > 1:
		%CycleTimer.wait_time = randf_range(cycle_duration_min, cycle_duration_max)
		%CycleTimer.start()


func _exit_state():
	%PlayerDetector.player_detected.disconnect(on_player_detected)
	%CycleTimer.stop()
	%StayTimer.stop()
	last_position = hunter.global_position


func get_data():
	if hunter.patrol_path != null:
		stay_duration = hunter.patrol_data.stay_duration
	else:
		stay_duration = 0.0
	
	look_right = hunter.patrol_data.look_right
	look_down = hunter.patrol_data.look_down
	look_left = hunter.patrol_data.look_left
	look_up = hunter.patrol_data.look_up
	if [look_right, look_down, look_left, look_up].count(true) > 2:
		cycle_mode = hunter.patrol_data.cycle_mode
	else:
		cycle_mode = CLOCKWISE
	always_new = hunter.patrol_data.always_new
	cycle_duration_min = hunter.patrol_data.duration_min
	cycle_duration_max = hunter.patrol_data.duration_max


func _on_cycle_timer_timeout() -> void:
	%CycleTimer.wait_time = randf_range(cycle_duration_min, cycle_duration_max)
	%CycleTimer.start()

	match cycle_mode:
		0: # clockwise
			match hunter.current_facing:
				Vector2.RIGHT:
					if look_down:
						hunter.face_down()
					elif look_left:
						hunter.face_left()
					elif look_up:
						hunter.face_up()
				
				Vector2.DOWN:
					if look_left:
						hunter.face_left()
					elif look_up:
						hunter.face_up()
					elif look_right:
						hunter.face_right()
				
				Vector2.LEFT:
					if look_up:
						hunter.face_up()
					elif look_right:
						hunter.face_right()
					elif look_down:
						hunter.face_down()
				
				Vector2.UP:
					if look_right:
						hunter.face_right()
					elif look_down:
						hunter.face_down()
					elif look_left:
						hunter.face_left()
		
		1: # counter-clockwise
			match hunter.current_facing:
				Vector2.RIGHT:
					if look_up:
						hunter.face_up()
					elif look_left:
						hunter.face_left()
					elif look_down:
						hunter.face_down()
				
				Vector2.UP:
					if look_left:
						hunter.face_left()
					elif look_down:
						hunter.face_down()
					elif look_right:
						hunter.face_right()
				
				Vector2.LEFT:
					if look_down:
						hunter.face_down()
					elif look_right:
						hunter.face_right()
					elif look_up:
						hunter.face_up()
				
				Vector2.DOWN:
					if look_right:
						hunter.face_right()
					elif look_up:
						hunter.face_up()
					elif look_left:
						hunter.face_left()
		
		2: # random
			while true:
				match randi() % 4:
					0:
						if (!always_new or hunter.current_facing != Vector2.RIGHT) and look_right:
							hunter.face_right()
							break
					
					1:
						if (!always_new or hunter.current_facing != Vector2.DOWN) and look_down:
							hunter.face_down()
							break
					
					2:
						if (!always_new or hunter.current_facing != Vector2.LEFT) and look_left:
							hunter.face_left()
							break
					
					3:
						if (!always_new or hunter.current_facing != Vector2.UP) and look_up:
							hunter.face_up()
							break


func _on_stay_timer_timeout() -> void:
	state_machine.change_state(%Patrolling)


func on_player_detected():
	state_machine.change_state(%Chasing)
