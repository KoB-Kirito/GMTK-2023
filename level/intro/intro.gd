extends Node


@export_file("*.tscn") var first_level: String

var dialog: Node


func _ready() -> void:
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	
	dialog = await Dialogic.start("intro")


func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(%Book, "modulate", Color("#ffffffff"), 10.0)


func _on_timeline_ended():
	%LevelchangeFadeOut.start()


func kill_dialog():
	dialog.queue_free()
