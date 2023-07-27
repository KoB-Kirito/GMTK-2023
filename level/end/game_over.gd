extends Control

@export_file("*.tscn") var level: String

func _on_reset_timer_timeout() -> void:
	get_tree().change_scene_to_file(level)
