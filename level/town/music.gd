extends Node

@export var fade_duration: float = 1.0

@onready var bgm_village: AudioStreamPlayer = $bgm_village
@onready var bgm_house: AudioStreamPlayer = $bgm_house
@onready var bgm_forest: AudioStreamPlayer = $bgm_forest


#func _ready() -> void:
#	fade(null, bgm_house, fade_duration)


func _on_forest_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	fade(bgm_village, bgm_forest, fade_duration)


func _on_forest_area_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	fade(bgm_forest, bgm_village, fade_duration)


func _on_house_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
		
	fade(bgm_village, bgm_house, fade_duration, true)


func _on_house_area_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	fade(bgm_house, bgm_village, fade_duration, true)


func fade(from: AudioStreamPlayer, to: AudioStreamPlayer, duration: float, cross_fade: bool = false):
	var target_volume = to.volume_db
	to.volume_db = -30.0
	
	if from != null and cross_fade:
		to.play(from.get_playback_position())
		
	else:
		to.play()
	
	var tween = create_tween()
	tween.tween_property(to, "volume_db", target_volume, duration)
	if from != null:
		var original_volume = from.volume_db
		tween.parallel().tween_property(from, "volume_db", -30.0, duration)
		tween.tween_callback(func(): from.stop())
		tween.tween_property(from, "volume_db", original_volume, 0.0)
