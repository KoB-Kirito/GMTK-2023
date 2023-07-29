class_name SearchingState
extends State


const CYCLE_MIN: float = 0.5
const CYCLE_MAX: float = 2.0

@onready var hunter := owner as Hunter


func _enter_state():
	%PlayerDetector.player_detected.connect(on_player_detected)
	%SearchMarker.visible = true
	%Navigation.navigation_finished.connect(on_target_reached)


func _exit_state():
	%PlayerDetector.player_detected.disconnect(on_player_detected)
	%SearchMarker.visible = false
	%Navigation.navigation_finished.disconnect(on_target_reached)
	%SearchTimer.stop()
	%SearchCycleTimer.stop()
	hunter.current_speed = hunter.default_speed


func on_player_detected():
	state_machine.change_state(%Chasing)


func on_target_reached():
	%SearchTimer.start()
	%SearchCycleTimer.start(randf_range(CYCLE_MIN, CYCLE_MAX))


func _on_search_cycle_timer_timeout() -> void:
	# search
	while true:
		match randi() % 4:
			0:
				if hunter.current_facing != Vector2.RIGHT:
					hunter.face_right()
					break
			
			1:
				if hunter.current_facing != Vector2.DOWN:
					hunter.face_down()
					break
			
			2:
				if hunter.current_facing != Vector2.LEFT:
					hunter.face_left()
					break
			
			3:
				if hunter.current_facing != Vector2.UP:
					hunter.face_up()
					break
	
	%SearchCycleTimer.start(randf_range(CYCLE_MIN, CYCLE_MAX))


func _on_search_timer_timeout() -> void:
	state_machine.change_state(%Returning)
