class_name Searching
extends State


func enter():
	%SearchMarker.visible = true
	%SearchTimer.start()


func exit():
	%SearchMarker.visible = false


func _on_search_timer_timeout() -> void:
	transition_to(%Returning)
