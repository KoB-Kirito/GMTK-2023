class_name Chasing
extends State


func enter():
	%PlayerDetector.player_lost.connect(on_player_lost)
	%ChaseMarker.visible = true


func exit():
	%PlayerDetector.player_lost.disconnect(on_player_lost)
	%ChaseMarker.visible = false


func on_player_lost():
	transition_to(%Searching)
