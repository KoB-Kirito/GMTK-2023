extends Node


func _ready() -> void:
	Dialogic.signal_event.connect(on_dialogic_signal)
	Dialogic.timeline_ended.connect(on_timeline_ended)
	
	Dialogic.start("intro")


func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(%Book, "modulate", Color("#ffffffff"), 10.0)


func on_dialogic_signal(argument: String):
	match argument:
		"noskip":
			pass
			# ToDo: disable skipping
		
		"skip":
			pass
			# ToDo: enable skipping


func on_timeline_ended():
	get_tree().change_scene_to_file("res://level/town.tscn")
