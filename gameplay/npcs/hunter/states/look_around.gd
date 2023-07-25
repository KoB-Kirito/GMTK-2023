class_name LookAround
extends State

var look_right: bool
var look_down: bool
var look_left: bool
var look_up: bool

var always_new: bool

@onready var hunter := owner as Hunter


func _ready() -> void:
	copy_settings()


func enter():
	#ToDo: get current settings from hunter
	
	%CycleTimer.wait_time = owner.look_cycle_duration
	%CycleTimer.start()


func copy_settings():
	look_right = hunter.look_right
	look_down = hunter.look_down
	look_left = hunter.look_left
	look_up = hunter.look_up
	look_mode = hunter.look


func _on_cycle_timer_timeout() -> void:
	pass # Replace with function body.

	match owner.look_mode:
		0: # clockwise
			match hunter.look_current:
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
			match hunter.look_current:
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
		
		2: # random, but new direction every time
			while true:
				match randi() % 4:
					0:
						if (!always_new or hunter.look_current != Vector2.RIGHT) and look_right:
							hunter.face_right()
							break
					
					1:
						if (!always_new or hunter.look_current != Vector2.DOWN) and look_down:
							hunter.face_down()
							break
					
					2:
						if (!always_new or hunter.look_current != Vector2.LEFT) and look_left:
							hunter.face_left()
							break
					
					3:
						if (!always_new or hunter.look_current != Vector2.UP) and look_up:
							hunter.face_up()
							break
