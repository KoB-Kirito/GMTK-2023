extends Control


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		return
	
	$TextureRect.gui_input.disconnect(_on_texture_rect_gui_input)
	$Menu.visible = true
