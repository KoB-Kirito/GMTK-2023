extends Control

@export var ingame_menu = false
@onready var switch = true


func _ready():
	if ingame_menu == true:
		hide()
		$Background.queue_free()
#		$CenterContainer/VBoxContainer/StartButton.set_texture_normal("")
#		$CenterContainer/VBoxContainer/StartButton.set_texture_pressed("")
#		$CenterContainer/VBoxContainer/StartButton.set_texture_hover("")


func _process(delta):
	if Input.is_action_just_pressed("esc_menu") and ingame_menu == true:
		esc_to_menu()


## make sure a button gets a focus for controller support
func _input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right") or event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		if button_visible_but_none_focused():
			%StartButton.grab_focus()


func button_visible_but_none_focused() -> bool:
	var button_visible: bool = false
	for button in %ButtonContainer.get_children():
		if button.visible:
			button_visible = true
			if button.has_focus():
				return false
		
	return button_visible


func esc_to_menu():
	visible = !visible
	get_tree().paused = visible
#	if Input.is_action_just_pressed("esc_menu") and ingame_menu and switch:
#		show()
#		switch != switch #false
#
#	if Input.is_action_just_pressed("esc_menu") and switch == false and ingame_menu:
#		hide()
#		switch != switch #true
		
		


func _on_start_button_pressed():
#	get_tree().unload_current_scene()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://intro/intro.tscn")


func _on_controls_button_pressed():
	$ControlsScreen.show()


func _on_settings_button_pressed():
	$SettingScreen.show()


func _on_credits_button_pressed():
	$CreditsScreen.show()


func _on_quit_button_pressed():
	get_tree().quit()
