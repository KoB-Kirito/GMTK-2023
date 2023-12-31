class_name ChasingState
extends State


var player: Player
@onready var hunter := owner as Hunter


func _enter_state():
	player = %PlayerDetector.player
	%PlayerDetector.player_lost.connect(on_player_lost)
	%PlayerDetector.player_detected.connect(on_player_detected)
	%ChaseMarker.visible = true
	%Navigation.target_position = %PlayerDetector.player.global_position
	hunter.current_speed = hunter.chasing_speed
	%UpdateTimer.start()
	Globals.hunter_saw_player.emit()


func _exit_state():
	%PlayerDetector.player_lost.disconnect(on_player_lost)
	%PlayerDetector.player_detected.disconnect(on_player_lost)
	%UpdateTimer.stop()
	%ChaseMarker.visible = false


func on_player_lost():
	%LoseTimer.start()


func on_player_detected():
	%LoseTimer.stop()


func _on_update_timer_timeout() -> void:
	# update pathfinding
	%Navigation.target_position = %PlayerDetector.player.global_position


func _on_lose_timer_timeout() -> void:
	state_machine.change_state(%Searching)
