extends Control


func _on_settings_back_button_pressed():
	hide()


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
