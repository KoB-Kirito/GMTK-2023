extends TextureProgressBar


var deny_animation_playing: bool = false


func play_deny_animation():
	if deny_animation_playing:
		return
	deny_animation_playing = true
	
	modulate = Color(1.0, 0.0, 0.0, 1.0)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.4)
	tween.tween_callback(func(): deny_animation_playing = false)
