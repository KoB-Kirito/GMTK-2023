extends CanvasLayer
## Handles transition animation into a level


signal transition_finished

@export var duration: float = 2.0
@export_color_no_alpha var color: Color = Color(0.0, 0.0, 0.0)
@export var bgm_player: AudioStreamPlayer


func _ready() -> void:
	%Fade.color = color
	
	var tween = create_tween()
	
	# fade in screen
	tween.tween_property(%Fade, "modulate", Color(1.0, 1.0, 1.0, 0.0), duration)
	
	# fade in background music if set
	if bgm_player != null:
		var default_volume = bgm_player.volume_db
		bgm_player.volume_db = -50.0
		bgm_player.play()
		tween.parallel().tween_property(bgm_player, "volume_db", default_volume, duration)
	
	# change scene
	tween.tween_callback(clear)


func clear():
	transition_finished.emit()
	call_deferred("queue_free")
