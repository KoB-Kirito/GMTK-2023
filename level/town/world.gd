extends Node2D


func _on_levelchange_fade_in_transition_finished() -> void:
	Dialogic.start("intro2")
