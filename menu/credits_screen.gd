extends Control


func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and not event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		queue_free()
