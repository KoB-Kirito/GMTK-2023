extends Control


func _ready() -> void:
	if Globals.used_controller and get_viewport().gui_get_focus_owner() != null:
		%ControlsBackButton.grab_focus()


func _on_controls_back_button_pressed():
	queue_free()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		queue_free()
		return
	
	%ControlsBackButton.grab_focus()
