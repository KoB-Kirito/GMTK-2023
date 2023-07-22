extends TextureProgressBar


@export_file("*.tscn") var next_level: String


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("interact"):
		value += 1
		%Label.visible = true
		
		if value == max_value:
			get_tree().paused = false
			owner.kill_dialog()
			get_tree().change_scene_to_file(next_level)
		
	else:
		value = 0
		%Label.visible = false
