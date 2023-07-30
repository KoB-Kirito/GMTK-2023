extends CanvasLayer


@export_file("*.tscn") var first_level
@export var controls_scene: PackedScene
@export var settings_scene: PackedScene
@export var credits_scene: PackedScene

var sub_on_screen: bool = false


func _ready() -> void:
	if first_level != "res://level/intro/intro.tscn":
		%StartLabel.text = "Restart"


## make sure a button gets a focus for controller support
func _unhandled_input(event: InputEvent) -> void:
	if sub_on_screen:
		return
	
	if Input.is_action_just_pressed("esc_menu"):
		esc_to_menu()
	
	if not visible:
		return
	
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right") or event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		if get_viewport().gui_get_focus_owner() == null:
			%StartButton.grab_focus()
			Globals.used_controller = true


func esc_to_menu():
	if get_tree().paused and not visible:
		return
	
	visible = !visible
	get_tree().paused = visible


func _on_start_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(first_level)


func _on_controls_button_pressed():
	open_sub_menu(controls_scene, %ControlsButton)


func _on_settings_button_pressed():
	open_sub_menu(settings_scene, %SettingsButton)


func _on_credits_button_pressed():
	if not sub_on_screen:
		open_sub_menu(credits_scene, %CreditsButton)


func open_sub_menu(menu_scene: PackedScene, button: TextureButton):
	var menu_instance = menu_scene.instantiate()
	menu_instance.tree_exited.connect(func():
			sub_on_screen = false
			if Globals.used_controller:
				button.grab_focus())
	sub_on_screen = true
	add_child(menu_instance)


func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu/title_screen.tscn")
