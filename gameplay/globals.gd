extends Node


func enable_pause() -> void:
	Dialogic.timeline_started.connect(on_dialog_started)
	Dialogic.timeline_ended.connect(on_dialog_ended)


func on_dialog_started():
	get_tree().paused = true

func on_dialog_ended():
	get_tree().paused = false
