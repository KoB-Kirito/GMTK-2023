extends Control
## Shows the main menu for any input but motion


func _input(event: InputEvent) -> void:
	if %Menu.visible:
		return
	
	if event is InputEventMouseMotion or event is InputEventJoypadMotion:
		print_debug("motion input")
		return
	
	%Menu.visible = true
