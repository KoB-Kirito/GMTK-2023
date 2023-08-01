extends CanvasLayer
## Handles transition animation out of a level


@export_file("*.tscn") var next_level: String
@export var duration: float = 2.0
@export_color_no_alpha var color: Color = Color(0.0, 0.0, 0.0)
@export var bgm_player: AudioStreamPlayer


func _ready() -> void:
	%Fade.color = color


func start(level: String = next_level) -> void:
	# catch inputs
	%Fade.mouse_filter = Control.MOUSE_FILTER_STOP
	get_tree().paused = true
	
	var tween = create_tween()
	
	# fade out screen
	tween.tween_property(%Fade, "modulate", Color(1.0, 1.0, 1.0, 1.0), duration)
	
	# fade out background music if set
	if bgm_player != null:
		tween.parallel().tween_property(bgm_player, "volume_db", -50.0, duration)
	
	# change scene
	tween.tween_callback(func():
			get_tree().paused = false
			get_tree().change_scene_to_file(next_level))
