class_name Returning
extends State


@onready var hunter := owner as Hunter


func enter():
	if hunter.patrol_path == null:
		# ToDo: return to watch position
		%ReturnTimer.start()
		
	else:
		# ToDo: get last location, move to last location
		pass


func _on_return_timer_timeout() -> void:
	transition_to(%Watching)
