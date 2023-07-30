extends Control


func _ready() -> void:
	if Globals.used_controller and get_viewport().gui_get_focus_owner() != null:
		%FullScreenCheckBox.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right") or event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		if get_viewport().gui_get_focus_owner() == null:
			%FullScreenCheckBox.grab_focus()


func _on_settings_back_button_pressed():
	queue_free()


func _on_full_screen_check_box_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)



func _on_v_sync_check_box_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_volume_slider_value_changed(value):
	volume(0, value)


func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)
