extends Control

@export var ingame_menu = false
@onready var switch = true


func _ready():
	if ingame_menu == true:
		hide()
#		$CenterContainer/VBoxContainer/StartButton.set_texture_normal("")
#		$CenterContainer/VBoxContainer/StartButton.set_texture_pressed("")
#		$CenterContainer/VBoxContainer/StartButton.set_texture_hover("")


func _process(delta):
	if Input.is_action_just_pressed("esc_menu") and ingame_menu == true:
		esc_to_menu()


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
	get_tree().change_scene_to_file("res://level/forest.tscn")


func _on_controls_button_pressed():
	$ControlsScreen.show()


func _on_settings_button_pressed():
	$SettingScreen.show()


func _on_credits_button_pressed():
	$CreditsScreen.show()


func _on_quit_button_pressed():
	get_tree().quit()
