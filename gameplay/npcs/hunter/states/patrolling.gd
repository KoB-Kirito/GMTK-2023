class_name Patrolling
extends State


var current_point: PatrolPoint

@onready var hunter := owner as Hunter


func enter():
	%PlayerDetector.player_detected.connect(on_player_detected)
	%Navigation.navigation_finished.connect(on_point_reached)
	
	if current_point == null:
		# get initial patrol point
		current_point = hunter.patrol_path.get_nearest_to(global_position)
	
	# move to current point
	%Navigation.target_position = current_point.global_position


func exit():
	%PlayerDetector.player_detected.disconnect(on_player_detected)
	%Navigation.navigation_finished.disconnect(on_point_reached)


func on_player_detected():
	transition_to(%Chasing)


func on_point_reached():
	if current_point.patrol_data and current_point.patrol_data.stay_duration > 0.0:
		hunter.patrol_data = current_point.patrol_data
		current_point = hunter.patrol_path.get_next_to(current_point)
		transition_to(%Watching)
		return
	
	# get next point
	current_point = hunter.patrol_path.get_next_to(current_point)
	
	if current_point == null:
		push_warning("path ended")
		return
	
	if current_point.patrol_data and current_point.patrol_data.speed_override > 0.0:
		hunter.current_speed = current_point.patrol_data.speed_override
	
	# move to current point
	%Navigation.target_position = current_point.global_position
