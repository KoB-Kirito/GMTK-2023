class_name Returning
extends State


@onready var hunter := owner as Hunter


func enter():
	Globals.hunter_lost_player.emit()
	if hunter.patrol_path == null:
		# move back to watch position
		%Navigation.target_position = %Watching.last_position
		%Navigation.navigation_finished.connect(on_last_position_reached)
		
	else:
		transition_to(%Patrolling)


func exit():
	%Navigation.navigation_finished.disconnect(on_last_position_reached)


func on_last_position_reached() -> void:
	# snap to exact position
	var tween = hunter.create_tween()
	tween.tween_property(hunter, "global_position", %Watching.last_position, 1.0)
	
	transition_to(%Watching)
